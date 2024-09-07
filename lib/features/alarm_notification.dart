// AlarmNotification.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AlarmNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    tz.initializeTimeZones();

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleAlarm({
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    // Calculate the notification time (10 minutes before due time)
    final DateTime notificationTime = dueDate.subtract(Duration(minutes: 10));

    // If the notification time is in the past, schedule it for immediate notification
    final DateTime now = DateTime.now();
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        notificationTime.isBefore(now) ? now : notificationTime, tz.local);
    print("Scheduling alarm for: $scheduledDate");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      title,
      description,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id', // Channel ID
          'your_channel_name', // Channel name
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}




// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
//
// class AlarmNotification {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final FlutterTts flutterTts = FlutterTts();
//
//   Future<void> initNotifications() async {
//     //initialize the timezone package
//     tz.initializeTimeZones();
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   }
//
//   Future<void> scheduleAlarm({
//     required String title,
//     required String description,
//     required DateTime dueDate,
// }) async {
//     final tenMinutesBefore = tz.TZDateTime.from(dueDate, tz.local)
//         .subtract(Duration(minutes: 10));
//
//     // Schedule the alarm only if the time is in the future
//
//     if (tenMinutesBefore.isAfter(DateTime.now())) {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'Task Reminder',
//         'You have 10 minutes to $title at $description',
//         tenMinutesBefore,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'your channel id',
//             'your channel name',
//             channelDescription: 'your channel description',
//             importance: Importance.high,
//             priority: Priority.high,
//           ),
//         ),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time,
//       );
//
//       await flutterTts.speak('You have 10 minutes to $title at $description');
//     }
//   }
// }