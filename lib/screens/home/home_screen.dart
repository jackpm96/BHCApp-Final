import 'dart:ui';

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/pages/calender_page.dart';
import 'package:black_history_calender/pages/dawer.dart';
import 'package:black_history_calender/pages/home_page.dart';
import 'package:black_history_calender/pages/search_page.dart';
import 'package:black_history_calender/pages/settings_page.dart';
import 'package:black_history_calender/services/auth_services.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
PageController pageController;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final FirebaseMessaging fcm = FirebaseMessaging.instance;
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     new FlutterLocalNotificationsPlugin();
  int selectedPage = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    // print(await fcm.getToken());
    //
    pageController = PageController(keepPage: false);
    await Prefs.id.then((value) {
      setState(() {
        id = value;
      });
    });

    // var initialzationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettings =
    //     InitializationSettings(android: initialzationSettingsAndroid);

    // flutterLocalNotificationsPlugin.initialize(initializationSettings);
    // FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    //     alert: true, badge: true, sound: true);
    // await FirebaseMessaging.instance.subscribeToTopic('new_post');
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification notification = message.notification;
    //   AndroidNotification android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             channelDescription: channel.description,
    //             icon: android.smallIcon,
    //           ),
    //         ));
    //   }
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((dynamic message) {
    //   if (Platform.isAndroid) {
    //     showAndroidCheckinoutAlert(message);
    //   } else {
    //     showiOSCheckinoutAlert(message);
    //   }
    // });

    // FirebaseMessaging.onMessage.listen((dynamic message) {
    //   if (Platform.isAndroid) {
    //     showAndroidCheckinoutAlert(message);
    //   } else {
    //     showiOSCheckinoutAlert(message);
    //   }
    // });
  }

  // showAndroidCheckinoutAlert(dynamic msg) {
  //   if (msg['data']['data'] != null) {
  //     showNotification(msg);
  //   }
  // }

  // showiOSCheckinoutAlert(RemoteMessage msg) {
  //   showiOSNotification(msg);
  // }

  // showNotification(Map<String, dynamic> msg) async {
  //   var android = new AndroidNotificationDetails(
  //     'MyGharCustomerApp',
  //     "MyGharNotificationChannel",
  //     channelDescription: "MyGhar Notifications for complaints and checkout",
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //   var iOS = new IOSNotificationDetails();
  //   var platform = new NotificationDetails(android: android, iOS: iOS);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, msg['notification']['title'], msg['notification']['body'], platform);
  // }

  // showiOSNotification(RemoteMessage msg) async {
  //   var android = new AndroidNotificationDetails(
  //     'MyGharCustomerApp',
  //     "MyGharNotificationChannel",
  //     channelDescription: "MyGhar Notifications for complaints and checkout",
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     showWhen: false,
  //   );
  //   var iOS = new IOSNotificationDetails();
  //   var platform = new NotificationDetails(android: android, iOS: iOS);

  //   flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       msg.notification.title,
  //       msg.notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,
  //           channelDescription: channel.description,
  //           icon: 'some_icon_in_drawable_folder',
  //         ),
  //       ));
  // }

  @override
  dispose() {
    super.dispose();
  }

  int _currentIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    CalenderPage(),
    BookMarkPage(
      showAppBar: false,
    ),
    SettingsPage(),
  ];
  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    pageController.jumpToPage(0);
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      CommonWidgets.buildSnackbar(context, "Press Again To Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerScreen(),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SizedBox.expand(
          child: PageView(
              controller: pageController,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling: true,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: <Widget>[
                HomePage(),
                CalenderPage(),
                BookMarkPage(
                  showAppBar: false,
                ),
                SettingsPage(),
              ]),
        ),
      ),

      // body: WillPopScope(
      //   onWillPop: () async {
      //     final isFirstRouteInCurrentTab =
      //         !await _pageOptions[selectedPage].naviKey.currentState.maybePop();
      //     if (isFirstRouteInCurrentTab) {
      //       if (selectedPage != 0) {
      //         setState(() {
      //           selectedPage = 0;
      //         });
      //         _selectTab(0);
      //         return false;
      //       }
      //     }
      //     // let system handle back button if we're on the first route
      //     return isFirstRouteInCurrentTab;
      //     // if (this.selectedPage == 2) return true;
      //     // setState(() {
      //     //   this.selectedPage = 2;
      //     // //  onTap(0);
      //     // });
      //     // return false;
      //   },
      //   child: IndexedStack(
      //       index: selectedPage,
      //       children: _pageOptions
      //           .map(
      //               (e) => _navigationTab(naviKey: e.naviKey, widget: e.widget))
      //           .toList()),
      // ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: white,
      //   child: Icon(
      //     Icons.add,
      //     color: lightBlue,
      //     size: 30,
      //   ),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => StoryForm()));
      //   },
      // ),
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,

        // shape: CircularNotchedRectangle(),
        // notchMargin: 10,
        child: Container(
            decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            height: 60,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                      size: 28,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      size: 25,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search_outlined,
                      size: 28,
                    ),
                    label: ""),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      size: 28,
                    ),
                    label: ""),
              ],
              selectedItemColor: white,
              elevation: 0.0,

              unselectedItemColor: white.withOpacity(0.7),
              // currentIndex: selectedPage,
              backgroundColor: Colors.transparent,
              // onTap: (index) {
              //   _selectTab(index);
              //   setState(() {
              //     selectedPage = index;
              //   });
              // }
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  pageController.jumpToPage(index);
                });
              },
            )),
      ),
    );
  }
//
// Widget _navigationTab({GlobalKey<NavigatorState> naviKey, Widget widget}) {
//   return Navigator(
//     key: naviKey,
//     onGenerateRoute: (routeSettings) {
//       return MaterialPageRoute(builder: (context) => widget);
//     },
//   );
// }

// void _selectTab(int index) {
//   if (index == selectedPage) {
//     _pageOptions[index]
//         .naviKey
//         .currentState
//         .popUntil((route) => route.isFirst);
//   } else {
//     setState(() {
//       selectedPage = index;
//     });
//   }
// }

}

// class Navi {
//   final Widget widget;
//   final Icon icon;
//   final GlobalKey<NavigatorState> naviKey;
//
//   Navi({@required this.widget, @required this.icon, @required this.naviKey});
// }
//
// class Calendar extends StatefulWidget {
//   Calendar({
//     Key key,
//     @required this.pageController,
//   }) : super(key: key);
//
//   PageController pageController;
//
//   @override
//   _CalendarState createState() => _CalendarState();
// }
//
// class _CalendarState extends State<Calendar> {
//   DateTime focusedDay = DateTime.now();
//   String headerText;
//
//   @override
//   void initState() {
//     headerText = DateFormat.MMMM().format(focusedDay);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       //  height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       decoration:
//           BoxDecoration(color: white, borderRadius: BorderRadius.circular(20)),
//       child: Column(
//         children: [
//           Container(
//             color: lightBlue,
//             width: MediaQuery.of(context).size.width,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     widget.pageController.previousPage(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeOut,
//                     );
//                     focusedDay = focusedDay.subtract(const Duration(days: 30));
//                   },
//                   icon: const Icon(
//                     Icons.keyboard_arrow_left,
//                     color: white,
//                     size: 30,
//                   ),
//                 ),
//                 Text(
//                   headerText,
//                   style:
//                       GoogleFonts.montserrat(color: white, fontSize: 20),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     widget.pageController.nextPage(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeOut,
//                     );
//                     focusedDay = focusedDay.add(const Duration(days: 30));
//                   },
//                   icon: const Icon(
//                     Icons.keyboard_arrow_right,
//                     color: white,
//                     size: 30,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           TableCalendar(
//             calendarStyle: CalendarStyle(
//               todayDecoration: BoxDecoration(
//                   color: lightBlue, shape: BoxShape.circle),
//             ),
//             firstDay: DateTime.utc(2010, 10, 16),
//             lastDay: DateTime.utc(2030, 3, 14),
//             focusedDay: focusedDay,
//             onPageChanged: (a) {
//               setState(() {
//                 focusedDay = a;
//                 headerText = DateFormat.MMMM().format(a);
//               });
//
//               print(headerText);
//             },
//             onCalendarCreated: (controller) =>
//                 widget.pageController = controller,
//             headerVisible: false,
//           ),
//         ],
//       ),
//     );
//   }
// }
