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

    const InitializationSettings settings = InitializationSettings(android: androidInitializationSettings);

    await _localNotificationService.initialize(settings);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'channel_id', 'channel_name',
        channelDescription: 'description', importance: Importance.max, priority: Priority.max, playSound: true);
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

  Future<void> showScheduledNotification(
      {required int id, required String title, required String body, required int seconds}) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
        id, title, body, tz.TZDateTime.from(DateTime.now().add(Duration(seconds: seconds)), tz.local), details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
}
