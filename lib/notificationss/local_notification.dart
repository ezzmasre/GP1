import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void startCustomTimer({
    required String title,
    required String body,
    required int seconds,
  }) {
    Timer(Duration(seconds: seconds), () {
      scheduleNotification(title: title, body: body);
    });
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'custom_notifications', // Channel ID
      'Custom Notifications', // Channel name
      channelDescription: 'This channel is for custom notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      title, // User-provided title
      body, // User-provided body
      platformChannelSpecifics,
    );
  }
}
