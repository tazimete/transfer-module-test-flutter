import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_filex/open_filex.dart';

/// Service for managing local system tray and push notifications.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
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

  Future<void> showUploadCompleteNotification({
    required String title,
    required String body,
  }) async {
    await init();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'upload_channel_id',
      'File Uploads',
      channelDescription: 'Notifications for completed file uploads',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'Upload Complete',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id: 1001,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
    );
  }

  Future<void> showDownloadProgressNotification({
    required int id,
    required String title,
    required String body,
    required int progress,
    required bool isCompleted,
    String? filePath,
  }) async {
    await init();

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
  }
}
