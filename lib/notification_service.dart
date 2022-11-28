import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// https://www.youtube.com/watch?v=Yrq2llD2Ldw    9'55
// https://romannurik.github.io/AndroidAssetStudio/index.html

// https://forum.devsach.in/discussion/38/flutter-local-notifications-the-resource-ic-launcher-could-not-be-found

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin {
    return _localNotificationService;
  }

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings settings =
        InitializationSettings(android: androidInitializationSettings);

    await _localNotificationService.initialize(settings);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);
    return const NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  // Shows the notification at the passed DateTime even if the app is closed
  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime date}) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
        id, title, body, tz.TZDateTime.from(date, tz.local), details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  // Schedules all the notifications for a week between 'from" to "to" daily, from now
  // Returns the Datetime of the last scheduled notification.
  Future<DateTime> scheduleNotifications(String title, String body, int period,
      TimeOfDay from, TimeOfDay to) async {
    final DateTime now = DateTime.now();
    final DateTime start =
        DateTime(now.year, now.month, now.day, from.hour, from.minute);
    final DateTime stop = start.add(const Duration(days: 7));
    final periodDuration = Duration(hours: period);
    final List<DateTime> schedules = [];
    DateTime current = start;
    while (current.isBefore(stop)) {
      if (current.isAfter(start)) {
        schedules.add(current);
      }
      current = current.add(periodDuration);
    }
    int id = 0;
    for (var schedule in schedules) {
      showScheduledNotification(
          id: id, title: title, body: body, date: schedule);
      id += 1;
    }
    return stop;
  }
}
