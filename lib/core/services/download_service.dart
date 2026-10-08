import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

/// Service managing background file downloads with persistent system notification progress
/// and safe file opening upon completion.
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
    _isInitialized = true;
  }

  /// Starts downloading a file. Continues running in background if user navigates away.
  Future<void> startBackgroundDownload({
    required String fileUrl,
    required String fileName,
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

      await _updateNotification(
        id: 2001,
        title: 'Downloading $sanitizedName',
        body: 'Progress: 0%',
        progress: 0,
        isCompleted: false,
      );

      int lastReportedPercent = -1;

      await _dio.download(
        fileUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final double progress = received / total;
            final int percent = (progress * 100).toInt();

            onProgress?.call(progress);

            if (percent != lastReportedPercent && (percent % 10 == 0 || percent == 100)) {
              lastReportedPercent = percent;
              _updateNotification(
                id: 2001,
                title: 'Downloading $sanitizedName',
                body: 'Progress: $percent%',
                progress: percent,
                isCompleted: false,
              );
            }
          }
        },
      );

      final file = File(savePath);
      if (await file.exists()) {
        await _updateNotification(
          id: 2001,
          title: 'Download Complete',
          body: 'Tap to open $sanitizedName',
          progress: 100,
          isCompleted: true,
          filePath: savePath,
        );

        onComplete?.call(savePath);

        try {
          final result = await OpenFilex.open(savePath);
          if (result.type != ResultType.done) {
            debugPrint('OpenFilex returned non-done result: ${result.message}');
          }
        } catch (e) {
          debugPrint('Error opening file: $e');
        }
      } else {
        throw Exception('Downloaded file not found at path');
      }
    } catch (e) {
      debugPrint('Background download error: $e');
      await _updateNotification(
        id: 2001,
        title: 'Download Failed',
        body: 'Could not download file: $e',
        progress: 0,
        isCompleted: false,
      );
      onError?.call(e);
    }
  }

  Future<void> _updateNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required bool isCompleted,
    String? filePath,
  }) async {
    try {
      AndroidNotificationDetails androidPlatformChannelSpecifics;

      if (isCompleted) {
        androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'download_channel_id',
          'File Downloads',
          channelDescription: 'Notifications for file downloads',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: false,
          autoCancel: true,
        );
      } else {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'download_channel_id',
          'File Downloads',
          channelDescription: 'Notifications for file downloads',
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
        );
      }

      final NotificationDetails platformChannelSpecifics = NotificationDetails(
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
      debugPrint('Notification update error: $e');
    }
  }
}
