import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize the plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (_) async {},
    );
  }

  static Future<void> scheduleDailyNotification() async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      '00.23',
      'moneyquipo',
      importance: Importance.high,
      priority: Priority.high,
    );
    const DarwinNotificationDetails ios = DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: android, iOS: ios);

    // await _notification.cancelAll();

    await _notification.periodicallyShow(
      0,
      'Daily Reminder',
      'This is your daily reminder message',
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: 'Daily Reminder',
    );
  }

  static Future<void> cancelNotifications() async {
    await _notification.cancelAll();
  }
}
