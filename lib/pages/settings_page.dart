import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchValue = false;
  bool switchEmailValue = false;
  int Nstatus = 0;
  int Estatus = 0;
  String name = '';

  @override
  void initState() {
    super.initState();
    getinitdata();
  }

  Future getinitdata() async {
    await Prefs.notiStatus.then((value) => setState(() {
          switchValue = value;
        }));
    await Prefs.emailStatus.then((value) => setState(() {
          switchEmailValue = value;
        }));
    await Prefs.name.then((value) {
      setState(() {
        name = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              scaffoldKey.currentState.openDrawer();
            },
            child: Icon(Icons.menu)),
        backgroundColor: lightBlue,
        elevation: 0.0,
        title: Text('SETTINGS'),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: lightBlue,
              height: 150,
              width: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 120,
                      child: CachedNetworkImage(
                        color: Colors.black45,
                        fit: BoxFit.cover,
                        imageUrl: 'user.featuredMediaSrcUrl',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, image) => Image.asset(
                          'assets/images/bhc_logo.png',
                          height: 100,
                          width: 120,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/bhc_logo.png',
                          height: 100,
                          width: 120,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   name,
                    //   style: GoogleFonts.montserrat(
                    //       color: white,
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 14),
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    launch("https://myblackhistorycalendar.com/terms-conditions/");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 0.2,
                          style: BorderStyle.solid,
                        ),
                      )),
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.rule_folder,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Terms & Conditions',
                              style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    // height: 40,
                    decoration: BoxDecoration(
                        //   color: Colors.blue.shade50,
                        //  borderRadius: BorderRadius.all(Radius.circular(5))
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.grey, //_focus.hasFocus ? Colors.blue :
                        width: 0.2,
                        style: BorderStyle.solid,
                      ),
                    )),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notifications,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Push Notification',
                              style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                              activeColor: Colors.blue,
                              value: switchValue,
                              onChanged: (val) {
                                setState(() {
                                  switchValue = val;
                                  tempfunction();
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        //   color: Colors.blue.shade50,
                        //  borderRadius: BorderRadius.all(Radius.circular(5))
                        border: Border(
                      bottom: BorderSide(
                        color: Colors.grey, //_focus.hasFocus ? Colors.blue :
                        width: 0.2,
                        style: BorderStyle.solid,
                      ),
                    )),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Receive Emails ',
                              style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                              activeColor: Colors.blue,
                              value: switchEmailValue,
                              onChanged: (val) {
                                setState(() {
                                  switchEmailValue = val;
                                  tempfunction();
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  void getnotistatus() {
    if (switchValue == true) {
      Nstatus = 1;
    } else {
      Nstatus = 0;
    }
  }

  void getEmailstatus() {
    if (switchEmailValue == true) {
      Estatus = 1;
    } else {
      Estatus = 0;
    }
  }

  Future tempfunction() async {
    getnotistatus();
    getEmailstatus();
    var response = await Provider.of<AuthProvider>(context, listen: false).SettingInfo(Nstatus, Estatus);
    if (Nstatus == 1) {
      await FirebaseMessaging.instance.subscribeToTopic('new_post');
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('new_post');
    }
    Prefs.setNotiStatus(switchValue);
    Prefs.setEmailStatus(switchEmailValue);
  }
}
