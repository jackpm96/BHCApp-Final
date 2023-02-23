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
  }

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
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
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
}
