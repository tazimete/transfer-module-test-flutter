import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

/// Singleton service managing background file downloads independent of screen lifecycle.
/// Continues running when navigating away or pressing back, showing real-time progress in system tray.
class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final Dio _dio = Dio();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        if (details.payload != null && details.payload!.isNotEmpty) {
          try {
            await OpenFilex.open(details.payload!);
          } catch (e) {
            debugPrint('Error opening file from notification: $e');
          }
        }
      },
    );

    // Create Android notification channel for progress
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'download_channel_id',
      'File Downloads',
      description: 'Notifications for file download progress',
      importance: Importance.low,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _isInitialized = true;
  }

  /// Starts background download. Continues running even if view is popped/minimized.
  Future<void> startBackgroundDownload({
    required String fileUrl,
    required String fileName,
    String? token,
    void Function(double progress)? onProgress,
    void Function(String filePath)? onComplete,
    void Function(Object error)? onError,
  }) async {
    await init();

    try {
      final dir = await getApplicationDocumentsDirectory();

      String sanitizedName = fileName.trim();
      if (sanitizedName.isEmpty || !sanitizedName.contains('.')) {
        sanitizedName = '${sanitizedName.isEmpty ? "downloaded_file" : sanitizedName}.pdf';
      }

      final savePath = '${dir.path}/$sanitizedName';

      // Show initial 0% progress notification
      await _showProgressNotification(
        id: 3001,
        title: 'Downloading $sanitizedName',
        progress: 0,
      );

      int lastReportedPercent = -1;

      final options = Options(
        headers: token != null && token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null,
      );

      await _dio.download(
        fileUrl,
        savePath,
        options: options,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final double progress = received / total;
            final int percent = (progress * 100).toInt();

            onProgress?.call(progress);

            if (percent != lastReportedPercent && (percent % 5 == 0 || percent == 100)) {
              lastReportedPercent = percent;
              _showProgressNotification(
                id: 3001,
                title: 'Downloading $sanitizedName',
                progress: percent,
              );
            }
          }
        },
      );

      final file = File(savePath);
      if (await file.exists()) {
        // Show completion notification (tap to open)
        await _showCompletionNotification(
          id: 3001,
          title: 'Download Complete',
          body: 'Tap to open $sanitizedName',
          filePath: savePath,
        );

        onComplete?.call(savePath);

        // Open file immediately
        try {
          await OpenFilex.open(savePath);
        } catch (e) {
          debugPrint('Error opening file: $e');
        }
      } else {
        throw Exception('Downloaded file not found at path');
      }
    } catch (e) {
      debugPrint('Background download error: $e');
      await _showErrorNotification(
        id: 3001,
        title: 'Download Failed',
        body: 'Error: $e',
      );
      onError?.call(e);
    }
  }

  Future<void> _showProgressNotification({
    required int id,
    required String title,
    required int progress,
  }) async {
    try {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'download_channel_id',
        'File Downloads',
        channelDescription: 'Notifications for file download progress',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        showProgress: true,
        maxProgress: 100,
        progress: progress,
      );

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: 'Progress: $progress%',
        notificationDetails: platformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('Progress notification error: $e');
    }
  }

  Future<void> _showCompletionNotification({
    required int id,
    required String title,
    required String body,
    required String filePath,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'download_channel_id',
        'File Downloads',
        channelDescription: 'Notifications for file download progress',
        importance: Importance.high,
        priority: Priority.high,
        ongoing: false,
        autoCancel: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: filePath,
      );
    } catch (e) {
      debugPrint('Completion notification error: $e');
    }
  }

  Future<void> _showErrorNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'download_channel_id',
        'File Downloads',
        channelDescription: 'Notifications for file download progress',
        importance: Importance.high,
        priority: Priority.high,
        ongoing: false,
        autoCancel: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
      );
    } catch (e) {
      debugPrint('Error notification error: $e');
    }
  }
}
