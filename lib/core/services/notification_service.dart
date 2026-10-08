import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
}
