import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/firebase_notification.dart';
import 'package:black_history_calender/screens/auth/sign_in_screen.dart';
import 'package:black_history_calender/screens/auth/sign_up_screen.dart';
import 'package:black_history_calender/services/auth_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key, this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(gradient: backGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text(
                  'Welcome To',
                  style: GoogleFonts.montserrat(
                      color: white, fontSize: 44, fontWeight: FontWeight.w400),
                ),
                Text(
                  'My Black History Calendar',
                  style: GoogleFonts.montserrat(
                    color: white.withOpacity(0.85),
                    fontSize: 18,
                  ),
                )
              ],
            ),
            Text(
              '365 Days of Black\nExcellence',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: white, fontSize: 25, fontWeight: FontWeight.w500),
            ),
            Column(
              children: [
                Divider(
                  color: white,
                  thickness: 0.2,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Each Day Celebrates the\nContributions of Our Sisters\n and Brothers',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: white, fontSize: 18, fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  color: white,
                  thickness: 0.2,
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 66),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    },
                    child: Card(
                      elevation: 4,
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                color: textBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: white, width: 1)),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: white,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
