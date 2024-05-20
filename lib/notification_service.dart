
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart';

// DateTime dateTime = DateTime.now();
// TZDateTime tzDateTime = TZDateTime.from(dateTime,);


// // Initialize the plugin
// final androidNotif = FlutterLocalNotificationsPlugin();

// // Schedule a push notification
// void scheduleNotification(DateTime scheduledDate, String title, String body) async {
//   // Create the notification details
//   var androidNotificationDetails = const AndroidNotificationDetails(
//     'channel_id',
//     'channel_name',
//     importance: Importance.max,
//     priority: Priority.high,
//   );

//   var notificationDetails = NotificationDetails(android: androidNotificationDetails);

//   await androidNotif.zonedSchedule(0, title, body, scheduledDate, notificationDetails, uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation)
// }
