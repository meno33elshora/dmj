import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

// 🔥 Top-Level Function for Handling Background Notifications
void onBackgroundNotificationTap(NotificationResponse notificationResponse) {
  debugPrint(
      "Notification tapped in background: ${notificationResponse.payload}");
}

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();

  factory NotificationHelper() {
    return _instance;
  }
  NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future init() async {
    await createNotificationChannel();
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      ),
    );
    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("Notification tapped: ${details.payload}");
      },
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationTap, // ✅ Fix applied here
    );
  }

  Future<void> scheduleNotification(
    String title,
    String body,
    DateTime selectedTime,
  ) async {
    if (selectedTime.isBefore(DateTime.now())) {
      selectedTime = selectedTime.add(Duration(
        days: selectedTime.day,
        hours: selectedTime.hour,
        minutes: selectedTime.minute,
      ));
    }
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.from(selectedTime, tz.local);

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        scheduledTime,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Notification scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}
