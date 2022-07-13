import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _localNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        if (payload != null) {
          Navigator.of(context).pushNamed(payload);
        }
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      int id = 0;

      NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails("zbgaming", "zbgaming channel",
              channelDescription: "This is a channel", importance: Importance.max, priority: Priority.high));

      await _localNotificationsPlugin.show(
          id, message.notification!.title, message.notification!.body, notificationDetails,
          payload: message.data["route"]);
    } on Exception catch (e) {
      print(e);
    }
  }
}
