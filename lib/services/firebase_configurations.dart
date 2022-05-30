import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class FirebaseMessagingManager {
  // String? _token;
  // BuildContext? context;
  // String screen = "";

  Future<void> init() async {
    await Firebase.initializeApp();
    getToken();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project ////

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('drawable/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (str) {
          Navigator.push(
            navigatorKey.currentState.context,
            MaterialPageRoute(
                builder: (context) => HomeScreen()
            ),
          );
      // ignore: avoid_print
      print('open app ${str}');
      Map<String, dynamic> data  = json.decode(str);
      // redirect(jsonDecode(str ?? ''));
    });





    FirebaseMessaging.onMessage.listen((message) {
      _notificationMessageHandler(message);
    });

    await FirebaseMessaging.instance.subscribeToTopic('new_post');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {

      Future.delayed(const Duration(milliseconds: 500), () {
        if (message != null) {
          // ignore: avoid_print
          print('background app');
        }
      });
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) async {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (message != null) {
          // ignore: avoid_print
          print("background notification ${message.data.toString()}");

        }
      });
    });
  }

  // void redirect(Map<String, dynamic> dat) async {
  //   print(dat);
  //   Map<String, dynamic> a = dat;
  //   screen = a["screen"] ?? '';
  //   if (screen == "new_post") {
  //     Future.delayed(Duration(milliseconds: 700), () {
  //       Navigator.pushNamed(AppComponentBase.getInstance().currentContext,
  //           RouteName.webViewDisplayPage,
  //           arguments: ItemArgument(data: {
  //             'url': a['service_id'] ?? '',
  //             'title': 'Blog',
  //             'id': 1
  //           }));
  //     });
  //   } else {
  //     print(a);
  //     LoginData? loginData = await AppComponentBase.getInstance()
  //         .getSharedPreference()
  //         .getUserDetail();
  //     if (loginData != null &&
  //         a['vehicle_id'] != null &&
  //         a['service_id'] != null) {
  //       AppComponentBase.getInstance()
  //           .getSharedPreference()
  //           .setSelectedVehicle(a['vehicle_id'].toString());
  //       getVehicleList(
  //           vehicle_id: a['vehicle_id'].toString(),
  //           service_id: a['service_id'].toString());
  //     }
  //   }
  // }

  Future<String> getToken() async {
    try {
      String _token = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $_token");
      return _token;
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("background notification ${message.data.toString()}");
  _notificationMessageHandler(message);
}

_notificationMessageHandler(RemoteMessage remoteMessage) async {
  RemoteNotification data =
      remoteMessage.notification ?? const RemoteNotification();

  if (data.title != null && data.body != null) {
    _showNotificationWithDefaultSound(remoteMessage);
  }
}

Future _showNotificationWithDefaultSound(RemoteMessage remoteMessage) async {
  RemoteNotification data =
      remoteMessage.notification ?? const RemoteNotification();
  // int id = int.parse(DateFormat('ddHHmmss').format(DateTime.now()));
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'title', 'bhc_channel_id',
      importance: Importance.max,
      playSound: true,
      styleInformation: BigTextStyleInformation(data.body ?? ''),
      priority: Priority.high);
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin?.show(
    1,
    data.title,
    data.body,
    platformChannelSpecifics,
    payload: jsonEncode(remoteMessage.data),
  );
}
