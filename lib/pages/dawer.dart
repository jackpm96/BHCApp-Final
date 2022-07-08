import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/pages/favorites_screen.dart';
import 'package:black_history_calender/services/auth_services.dart';
import 'package:black_history_calender/subsription_from_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/auth/sign_in_screen.dart';
import '../screens/splash.dart';
import 'my_profile.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool touchSwitch = false;
  bool isUserLoggedIn = false;

  @override
  initState() {
    initData();
    super.initState();
  }

  initData() async {
    await Prefs.manageTouch.then((value) => setState(() {
          touchSwitch = value;
        }));

    if (await Prefs.id != "") {
      setState(() {
        isUserLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: lightBlue,
            height: 200,
            width: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/bhc_logo.png',
            ),
          ),
          Expanded(
            child: Column(
              children: [
                !isUserLoggedIn
                    ? drawerTile('Sign In', Icons.login, context, () async {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const SignInScreen(),
                          ),
                          ModalRoute.withName('/'),
                        );
                      })
                    : drawerTile('My Account', Icons.person, context, () async {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyProfile()),
                        );
                      }),
                drawerTile('Favorites', Icons.favorite, context, () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(
                        showAppBar: true,
                      ),
                    ),
                  );
                }),
                drawerTile('Payments & Subscriptions', Icons.payments, context, () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionScreenFromHome(),
                    ),
                  );
                }),
                // drawerTile('Activity Log', Icons.local_activity, context, () {
                //   Navigator.pop(context);
                // }),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                      //   color: Colors.blue.shade50,
                      //  borderRadius: BorderRadius.all(Radius.circular(5))
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey, //_focus.hasFocus ? Colors.blue :
                          width: 0.2,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.notifications,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Manage Touch ID',
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              activeColor: Colors.blue,
                              value: touchSwitch,
                              onChanged: (val) {
                                setState(() {
                                  touchSwitch = val;
                                });

                                Prefs.setManageTouch(touchSwitch);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                drawerTile('Contact Us', Icons.contact_support, context, () {
                  Navigator.pop(context);
                  launch("https://myblackhistorycalendar.com/contact-us/");
                }),
                drawerTile('Privacy', Icons.privacy_tip, context, () {
                  Navigator.pop(context);
                  launch("https://myblackhistorycalendar.com/privacy-policy/");
                }),
                !isUserLoggedIn
                    ? Container()
                    : drawerTile('Log Out', Icons.logout, context, () async {
                        // await Prefs().clear();
                        EasyLoading.show(dismissOnTap: false);
                        await Prefs.setID('');
                        await Prefs.setUserName('');
                        await Prefs.setName('');
                        await Prefs.setFirstName('');
                        await Prefs.setLastName('');
                        await Prefs.setReadingStories('');
                        await Prefs.setSubsRole('');
                        await Prefs.setUserLogin('');
                        await Prefs.setDob('');
                        await Prefs.setImg('');
                        await Prefs.setRememberMe(false);
                        await Prefs.setNotiStatus(false);
                        await Prefs.setEmailStatus(false);
                        await Prefs.setManageTouch(false);
                        final auth = Auth();
                        await auth.signOut();
                        EasyLoading.dismiss();
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SplashScreen(
                              auth: Auth(),
                            ),
                          ),
                          ModalRoute.withName('/'),
                        );
                      })
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget drawerTile(String text, IconData icon, BuildContext context, void Function() _func) {
  return GestureDetector(
    onTap: _func,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        // height: 40,
        decoration: const BoxDecoration(
          //   color: Colors.blue.shade50,
          //  borderRadius: BorderRadius.all(Radius.circular(5))
          border: Border(
            bottom: BorderSide(
              color: Colors.grey, //_focus.hasFocus ? Colors.blue :
              width: 0.2,
            ),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
