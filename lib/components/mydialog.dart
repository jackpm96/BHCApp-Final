import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/screens/auth/sign_in_screen.dart';
import 'package:black_history_calender/services/auth_services.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/auth/sign_up_screen.dart';
import '../screens/splash.dart';
import '../subscription_from_home_android.dart';
import '../subsription_from_home.dart';
import '../widget/snackbar_widget.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}

showAlert(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: lightBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 55,
                  //  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Subscription Check",
                          style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 195,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You are not Subscribed!",
                                style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: lightBlue,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    if (await Prefs.id != "") {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Platform.isAndroid ? SubscriptionScreenFromHomeAndroid() : SubscriptionScreenFromHome(),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUpScreen(
                                                    goToSubscriptions: true,
                                                  )));
                                    }
                                  },
                                  child: Text(
                                    "Subscribe Now",
                                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "If you already have a subscription ",
                              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w400),
                            ),
                            InkWell(
                              onTap: () async {
                                // await Prefs().clear();
                                await Prefs.setID('');
                                await Prefs.setUserName('');
                                await Prefs.setName('');
                                await Prefs.setFirstName('');
                                await Prefs.setLastName('');
                                // await Prefs.setToken('');
                                // await Prefs.setReadingStories('');
                                await Prefs.setSubsRole('');
                                await Prefs.setDob('');
                                await Prefs.setRememberMe(false);
                                await Prefs.setNotiStatus(false);
                                await Prefs.setEmailStatus(false);
                                await Prefs.setManageTouch(false);
                                final auth = Auth();
                                await auth.signOut();
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => const SignInScreen(),
                                  ),
                                  ModalRoute.withName('/'),
                                );
                              },
                              child: Text(
                                "Login Now",
                                style: TextStyle(color: Colors.blue[900], fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

showDeleteAccountAlert(BuildContext context, text, id) {
  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  deleteAccount() async {
    try {
      EasyLoading.show(dismissOnTap: false);
      if (FirebaseAuth.instance.currentUser == null) {
        final response = await http.post(
          Uri.parse('https://myblackhistorycalendar.com/wp-json/wcra/v1/deleteuser/?secret_key=Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0&user_id=$id'),
        );
        if (response.statusCode == 200) {
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
          await Prefs.setMembership('0');
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
        }
        var result = jsonDecode(response.body);
        print('result $result');
      } else {
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);
        OAuthCredential oauthCredential;
        if (await GoogleSignIn().isSignedIn()) {
          await GoogleSignIn().signIn();
        } else if (await FacebookLogin().isLoggedIn) {
          await FacebookLogin().logIn(permissions: [
            FacebookPermission.publicProfile,
            FacebookPermission.email,
            // FacebookPermission.pagesShowList,
            FacebookPermission.userFriends
          ]);
        } else {
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: nonce,
          );
          oauthCredential = OAuthProvider("apple.com").credential(
            idToken: appleCredential.identityToken,
            rawNonce: rawNonce,
          );
          UserCredential user = await FirebaseAuth.instance.currentUser.reauthenticateWithCredential(oauthCredential);
        }
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.currentUser.delete();
          final response = await http.post(
            Uri.parse('https://myblackhistorycalendar.com/wp-json/wcra/v1/deleteuser/?secret_key=Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0&user_id=$id'),
          );
          if (response.statusCode == 200) {
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
            await Prefs.setMembership('0');
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
          }
          var result = jsonDecode(response.body);
          print('result $result');
        }
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Error: $e");
    }
  }

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: lightBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            // height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 55,
                  //  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Alert",
                          style: TextStyle(color: Colors.white, fontSize: 16.5, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$text",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Are you sure you want to permanently delete your account?",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () async {
                                deleteAccount();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.redAccent,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: lightBlue,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                                child: Text(
                                  "No",
                                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Platform.isAndroid
                            ? SizedBox()
                            : Text(
                                "Manage your subscriptions:  ",
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                        Platform.isAndroid
                            ? SizedBox(
                                height: 15,
                              )
                            : InkWell(
                                onTap: () async {
                                  await launch('https://apps.apple.com/account/subscriptions');
                                },
                                child: Text(
                                  "https://apps.apple.com/account/subscriptions.",
                                  style: TextStyle(
                                      color: Colors.blue[900], fontSize: 14, fontWeight: FontWeight.w400, decoration: TextDecoration.underline),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
