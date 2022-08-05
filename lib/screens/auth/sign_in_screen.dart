import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/screens/auth/forgot_password_screen.dart';
import 'package:black_history_calender/screens/auth/model/social_login_response.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:black_history_calender/screens/welcome_screen.dart';
import 'package:black_history_calender/services/auth_services.dart';
import 'package:black_history_calender/services/loca_auth_api.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:black_history_calender/widget/text_field_border.dart';
import 'package:black_history_calender/widget/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../helper/firebase_notification.dart';
import '../../subscription_from_home_android.dart';
import '../../subsription_from_home.dart';
import 'provider/auth_provider.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key, this.goToSubscriptions = false})
      : super(key: key);

  final bool goToSubscriptions;

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool switchValue = false;
  bool checkBoxVal = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  FocusNode _emailFocus = new FocusNode();
  FocusNode _passFocus = new FocusNode();
  final AuthBase auth = Auth();
  String token;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    await Prefs.rememberMe.then((value) {
      setState(() {
        checkBoxVal = value;
      });
    });
    await Prefs.token.then((value) {
      setState(() {
        token = value;
      });
    });
  }

  Future<void> _signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final OAuthCredential oauthCredential =
          OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      if (FirebaseAuth.instance.currentUser.displayName == "" ||
          FirebaseAuth.instance.currentUser.displayName == null) {
        await FirebaseAuth.instance.currentUser.updateDisplayName(
            "${appleCredential.givenName} ${appleCredential.familyName}");
      }

      EasyLoading.show(dismissOnTap: false);
      EasyLoading.dismiss();
      if (user.credential != null) {
        var token = await FirebaseAuth.instance.currentUser.getIdTokenResult();
        var accessToken = {
          "access_token": token.token,
          "token_type": "bearer",
          "expires_in": "3600"
        };
        var body = {
          "name": FirebaseAuth.instance.currentUser.displayName,
          "email": FirebaseAuth.instance.currentUser.email,
          "access_token": jsonEncode(accessToken),
          "login_type": "apple",
          "identifier": appleCredential.identityToken
        };

        print(body);
        EasyLoading.show(dismissOnTap: false);
        socialLoginApple(body).then((value) {
          EasyLoading.dismiss();
          if (value.code == 200) {
            Prefs.setToken(value.data.token.toString());
            Prefs.setID(value.data.userId.toString());
            Prefs.setDob(value.data.dob.toString());
            Prefs.setName(
                FirebaseAuth.instance.currentUser.displayName.toString());
            Prefs.setUserName(value.data.userNicename);
            if (user.user.photoURL != "" &&
                value.data.imgurl.toString() ==
                    "https://myblackhistorycalendar.com/wp-content/uploads/2022/04/gamer.png") {
              Prefs.setImg(user.user.photoURL);
            } else {
              Prefs.setImg(value.data.imgurl.toString());
            }
            if (FirebaseAuth.instance.currentUser.displayName
                    .toString()
                    .split(" ")
                    .length >
                0) {
              Prefs.setFirstName(FirebaseAuth.instance.currentUser.displayName
                  .toString()
                  .split(" ")
                  .first);
              Prefs.setLastName(FirebaseAuth.instance.currentUser.displayName
                  .toString()
                  .split(" ")
                  .last);
            } else {
              Prefs.setFirstName(
                  FirebaseAuth.instance.currentUser.displayName.toString());
              Prefs.setLastName("");
            }
            Prefs.setEmail(value.data.userEmail.toString());
            Prefs.setMembership(value.data.membershipLevel.toString());

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(
                          auth: auth,
                        )),
                ModalRoute.withName('/'));
          } else {
            CommonWidgets.buildSnackbar(context, "Something went wrong");
          }
        });
      }
    } catch (e) {
      print("error in apple login");
      print(e.toString());
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _signInWithGoogle() async {
    try {
      GoogleResponse user = await auth.signInWithGoogle();
      print("user $user");
      if (user != null) {
        var token = await user.user.getIdTokenResult();
        var accessToken = {
          "access_token": user.response.accessToken,
          "token_type": "bearer",
          "expires_in": token.expirationTime.millisecondsSinceEpoch.toString()
        };
        var body = {
          "name": user.user.displayName,
          "email": user.user.email,
          "access_token": jsonEncode(accessToken),
          "login_type": "google",
          "identifier": user.user.providerData[0].uid.toString()
        };

        print(body);
        EasyLoading.show(dismissOnTap: false);
        socialLoginGoogle(body).then((value) {
          EasyLoading.dismiss();
          if (value.code == 200) {
            Prefs.setToken(value.data.token.toString());
            Prefs.setID(value.data.userId.toString());
            Prefs.setDob(value.data.dob.toString());
            Prefs.setName(value.data.userDisplayName.toString());
            Prefs.setUserName(value.data.userNicename);
            if (user.user.photoURL != "" &&
                value.data.imgurl.toString() ==
                    "https://myblackhistorycalendar.com/wp-content/uploads/2022/04/gamer.png") {
              Prefs.setImg(user.user.photoURL);
            } else {
              Prefs.setImg(value.data.imgurl.toString());
            }
            if (value.data.userDisplayName.toString().split(" ").length > 0) {
              Prefs.setFirstName(
                  value.data.userDisplayName.toString().split(" ").first);
              Prefs.setLastName(
                  value.data.userDisplayName.toString().split(" ").last);
            } else {
              Prefs.setFirstName(value.data.userDisplayName.toString());
              Prefs.setLastName("");
            }
            Prefs.setEmail(value.data.userEmail.toString());
            Prefs.setMembership(value.data.membershipLevel.toString());

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(
                          auth: auth,
                        )),
                ModalRoute.withName('/'));
          } else {
            CommonWidgets.buildSnackbar(context, "Something went wrong");
          }
        });
      }
    } catch (e) {
      if (e
          .toString()
          .contains("FACEBOOK_PROVIDER_ALREADY_PRESENT")) {
        CommonWidgets.buildSnackbar(context,
            "You are already registered with your Facebook account, please sign in using your Facebook!");
      } else {
        CommonWidgets.buildSnackbar(context, "$e");
      }
      print("error in google login");
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      FacebookResponse user = await auth.signInWithFacebook();
      if (user != null) {
        var token = await user.user.getIdTokenResult();

        var accessToken = {
          "access_token": user.response.accessToken.token,
          "token_type": "bearer",
          "expires_in": token.expirationTime.millisecondsSinceEpoch.toString()
        };

        var body = {
          "name": user.user.displayName,
          "email": user.user.email,
          "access_token": jsonEncode(accessToken),
          "login_type": "fb",
          "identifier": user.response.accessToken.userId.toString()
        };

        EasyLoading.show(dismissOnTap: false);
        socialLoginFacebook(body).then((value) {
          EasyLoading.dismiss();
          if (value.code == 200) {
            Prefs.setToken(value.data.token.toString());
            Prefs.setID(value.data.userId.toString());
            Prefs.setDob(value.data.dob.toString());
            Prefs.setName(value.data.userDisplayName.toString());
            Prefs.setUserName(value.data.userNicename);
            if (user.user.photoURL != "" &&
                value.data.imgurl.toString() ==
                    "https://myblackhistorycalendar.com/wp-content/uploads/2022/04/gamer.png") {
              Prefs.setImg(user.user.photoURL);
            } else {
              Prefs.setImg(value.data.imgurl.toString());
            }

            if (value.data.userDisplayName.toString().split(" ").length > 0) {
              Prefs.setFirstName(
                  value.data.userDisplayName.toString().split(" ").first);
              Prefs.setLastName(
                  value.data.userDisplayName.toString().split(" ").last);
            } else {
              Prefs.setFirstName(value.data.userDisplayName.toString());
              Prefs.setLastName("");
            }

            Prefs.setEmail(value.data.userEmail.toString());
            Prefs.setMembership(value.data.membershipLevel.toString());

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(
                          auth: auth,
                        )),
                ModalRoute.withName('/'));
          } else {
            CommonWidgets.buildSnackbar(context, "Something went wrong");
          }
        });
      } else {}
    } catch (e) {
      if (e
          .toString()
          .contains("An account already exists with the same email address")) {
        CommonWidgets.buildSnackbar(context,
            "You are already registered with your google account please sign in using your registered google id");
      } else {
        CommonWidgets.buildSnackbar(context, "$e");
      }
      print(e.toString());
    }
  }

  Future<SocialLoginResponse> socialLoginFacebook(body) async {
    var url =
        'https://myblackhistorycalendar.com/wp-json/nextend-social-login/v1/facebook/get_user?name=${body['name']}&email=${body['email']}&access_token=${body['access_token']}&login_type=${body['login_type']}&identifier=${body['identifier']}';
    final response = await http.post(
      Uri.parse(url),
    );
    var result = jsonDecode(response.body);
    return SocialLoginResponse.fromJson(result as Map<String, dynamic>);
  }

  Future<SocialLoginResponse> socialLoginGoogle(body) async {
    var url =
        'https://myblackhistorycalendar.com/wp-json/nextend-social-login/v1/google/get_user?name=${body['name']}&email=${body['email']}&access_token=${body['access_token']}&login_type=${body['login_type']}&identifier=${body['identifier']}';
    final response = await http.post(
      Uri.parse(url),
    );
    var result = jsonDecode(response.body);

    return SocialLoginResponse.fromJson(result as Map<String, dynamic>);
  }

  Future<SocialLoginResponse> socialLoginApple(body) async {
    var url =
        'https://myblackhistorycalendar.com/wp-json/nextend-social-login/v1/apple/get_user?name=${body['name']}&email=${body['email']}&access_token=${body['access_token']}&login_type=${body['login_type']}&identifier=${body['identifier']}';
    final response = await http.post(
      Uri.parse(url),
    );
    var result = jsonDecode(response.body);

    return SocialLoginResponse.fromJson(result as Map<String, dynamic>);
  }

  Future<SocialLoginResponse> socialRegister(body) async {
    final response = await http.post(
      Uri.parse(
          'https://myblackhistorycalendar.com/wp-json/wcra/v1/addsocialuser/?secret_key=Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0&email=${body['email']}&login_type=fb&name=${body['name']}&identifier=${body['identifier']}'),
    );
    var result = jsonDecode(response.body);
    return SocialLoginResponse.fromJson(result as Map<String, dynamic>);
  }

  Future<void> _biofunction(switchValue) async {
    if (switchValue == true) {
      final isAuthenticated = await LocalAuthApi.authenticate();

      if (isAuthenticated) {
        await validateToken();
      }
    }
  }

  Future validateToken() async {
    await Provider.of<AuthProvider>(context, listen: false)
        .checkTokenValidate(token)
        .then((value) {
      if (value.code.contains("jwt_auth_valid_token")) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(
                      auth: auth,
                    )),
            ModalRoute.withName('/'));
      } else {
        showAlertDialog(
            context: context,
            title: "Alert",
            content: 'Session expired please login again',
            cancelActionText: null,
            defaultActionText: "OK",
            defaultFunc: () async {
              await Prefs().clear();
              await auth.signOut();
              Navigator.of(context).pop(true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => WelcomeScreen(auth: auth)),
              );
              return;
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        //keyboard pop-down
        onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Container(
          decoration: BoxDecoration(gradient: backGradient),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 190,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    height: 70,
                    width: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                      'assets/images/bhc_logo.png',
                    ))),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 25, left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Sign In',
                            style: GoogleFonts.montserrat(
                                color: Color(0xff666666),
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          TextFieldSideBorder(
                              tfieldController: _emailController,
                              focus: _emailFocus,
                              hint: "Username / Email",
                              icon: Icons.person,
                              keyboardType: TextInputType.emailAddress),
                          SizedBox(
                            height: 30,
                          ),
                          TextFieldSideBorder(
                            tfieldController: _passwordController,
                            focus: _passFocus,
                            hint: "Password",
                            icon: Icons.lock,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      value: checkBoxVal,
                                      onChanged: (val) {
                                        setState(() {
                                          checkBoxVal = val;
                                        });

                                        Prefs.setRememberMe(checkBoxVal);
                                      }),
                                  Text(
                                    'Remember Me',
                                    style: GoogleFonts.montserrat(
                                        color: Color(0xff0891d9),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassScreen()));
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.montserrat(
                                      color: Color(0xff0891d9),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Padding(
                          //       padding:
                          //           const EdgeInsets.symmetric(horizontal: 10),
                          //       child: Row(
                          //         children: [
                          //           Card(
                          //             color: Color(0xffd5ebf8),
                          //             elevation: 4,
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(4.0),
                          //             ),
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(4.0),
                          //               child: Image.asset(
                          //                 'assets/images/fingerprintt.png',
                          //                 width: 16,
                          //                 height: 16,
                          //                 fit: BoxFit.cover,
                          //                 color: Colors.blue,
                          //               ),
                          //             ),
                          //           ),
                          //           SizedBox(
                          //             width: 10,
                          //           ),
                          //           Text(
                          //             'Biometric Login',
                          //             style: GoogleFonts.montserrat(
                          //                 color: Color(0xff999999),
                          //                 fontSize: 13,
                          //                 fontWeight: FontWeight.w300),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     Transform.scale(
                          //       scale: 0.7,
                          //       child: CupertinoSwitch(
                          //           activeColor: Colors.blue,
                          //           value: switchValue,
                          //           onChanged: token != null && token.isNotEmpty
                          //               ? (val) {
                          //                   setState(() {
                          //                     switchValue = val;
                          //                     _biofunction(switchValue);
                          //                   });
                          //                 }
                          //               : (val) {
                          //                   showAlertDialog(
                          //                       context: context,
                          //                       title: "Alert",
                          //                       content:
                          //                           "You need to login first to enable biometric login feature",
                          //                       cancelActionText: null,
                          //                       defaultActionText: "OK",
                          //                       defaultFunc: null);
                          //                 }),
                          //     )
                          //   ],
                          // ),
                          SizedBox(
                            height: 25,
                          ),
                          GestureDetector(
                            onTap: signIn,
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Color(0xff0891d9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      color: white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            '-OR-',
                            style: GoogleFonts.montserrat(
                              color: Colors.grey,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: _signInWithFacebook,
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xffdddddd))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Image.asset('assets/images/fb.png'),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Sign In with Facebook',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: _signInWithGoogle,
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xffdddddd))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child:
                                        Image.asset('assets/images/google.png'),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Sign In with Google',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Platform.isIOS ? 8 : 0,
                          ),
                          Platform.isIOS
                              ? GestureDetector(
                                  onTap: _signInWithApple,
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.all(8),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Color(0xffdddddd))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: Image.asset(
                                                  'assets/images/apple.png')),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Sign In with Apple',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?  ',
                                style: GoogleFonts.montserrat(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpScreen()));
                                },
                                child: Text(
                                  'Sign Up Now',
                                  style: GoogleFonts.montserrat(
                                      color: lightBlue,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    EasyLoading.show(dismissOnTap: false);
    String ntoken = await FirebaseMessaging.instance.getToken();
    var response = await Provider.of<AuthProvider>(context, listen: false)
        .loginUser(_emailController.text.trim(),
            _passwordController.text.trim(), notification.token, context);
    if (response != null) {
      EasyLoading.dismiss();
      Prefs.setToken(response.token.toString());
      Prefs.setID(response.userId.toString());
      Prefs.setSubsRole(response.membershipLevel);
      Prefs.setName("${response.userFirstName}${response.userLastName}");
      Prefs.setFirstName("${response.userFirstName}");
      Prefs.setLastName("${response.userLastName}");
      Prefs.setEmail("${response.userEmail}");
      Prefs.setMembership("${response.membershipLevel}");
      Prefs.setDob(response.dob);
      Prefs.setImg(response.imgurl);
      Prefs.setUserLogin(response.userLogin);
      Prefs.setUserName(response.userNicename);
      CommonWidgets.buildSnackbar(context, "Sign In successful");
      if (widget.goToSubscriptions) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Platform.isAndroid
                ? SubscriptionScreenFromHomeAndroid()
                : SubscriptionScreenFromHome(),
          ),
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
      }
    } else {
      EasyLoading.dismiss();
    }
  }
}
