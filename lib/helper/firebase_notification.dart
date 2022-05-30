import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String token;

  String get getToken => token;
  set setToken(String val) {
    token = val;
  }

  Future<void> configure(BuildContext context) async {
    token = await fcm.getToken();
    if (Platform.isIOS) {
      fcm.requestPermission(sound: true, badge: true, alert: true);
    }

    // FirebaseMessaging.onMessageOpenedApp.listen((dynamic message) {
    //   print('Message clicked!');
    //   if (Platform.isAndroid) {
    //     showAndroidCheckinoutAlert(message);
    //   } else {
    //     showiOSCheckinoutAlert(message);
    //   }
    // });

    // FirebaseMessaging.onMessage.listen((dynamic message) {
    //   print("Gotcha");
    //   if (Platform.isAndroid) {
    //     showAndroidCheckinoutAlert(message);
    //   } else {
    //     showiOSCheckinoutAlert(message);
    //   }
    // });
  }

  showAndroidCheckinoutAlert(Map<String, dynamic> msg) {
    if (msg['data']['data'] != null) {
      showNotification(msg);
    }
  }

  showiOSCheckinoutAlert(RemoteMessage msg) {
    showiOSNotification(msg);
  }

  showNotification(Map<String, dynamic> msg) async {
    const android = AndroidNotificationDetails(
      'MyGharCustomerApp',
      "MyGharNotificationChannel",
      channelDescription: "MyGhar Notifications for complaints and checkout",
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
      // ignore: avoid_dynamic_calls
      0, msg['notification']['title'].toString(), msg['notification']['body'].toString(), platform,
    );
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  showiOSNotification(RemoteMessage msg) async {
    const android = AndroidNotificationDetails(
      'MyGharCustomerApp',
      "MyGharNotificationChannel",
      channelDescription: "MyGhar Notifications for complaints and checkout",
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const iOS = IOSNotificationDetails();
    const platform = NotificationDetails(android: android, iOS: iOS);
    // await flutterLocalNotificationsPlugin.show(
    //     0, msg.notification.title, msg.notification.body, platform);

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      msg.notification.title,
      msg.notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'some_icon_in_drawable_folder',
        ),
      ),
    );
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'my_channel',
  'My Channel',
  description: 'Important notifications from my server.',
  importance: Importance.high,
);

Notification notification = Notification();
