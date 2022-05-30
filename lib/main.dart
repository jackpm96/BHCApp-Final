import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/splash.dart';
import 'package:black_history_calender/services/auth_services.dart';
import 'package:black_history_calender/services/firebase_configurations.dart';
import 'package:black_history_calender/services/payment_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

void main() async {
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseMessagingManager().init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp( );



  await PaymentService.instance.initConnection();


  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            lazy: false, create: (context) => AuthProvider()),
      ],
      child: MaterialApp(

        title: 'BHC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          sliderTheme:
              SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(
          auth: Auth(),
        ),
        builder: (BuildContext context, Widget child) {
          return FlutterEasyLoading(child: child);
        },
      ),
    );
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print("fcm token $token");
  }

  // getTopics() async {
  //   await FirebaseFirestore.instance
  //       .collection('topics')
  //       .get()
  //       .then((value) => value.docs.forEach((element) {
  //             if (token == element.id) {
  //               subscribed = element.data().keys.toList();
  //             }
  //           }));

  //   setState(() {
  //     subscribed = subscribed;
  //   });
  // }
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.data}');
}