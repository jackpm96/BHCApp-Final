import 'dart:convert';
import 'dart:convert' as convert;

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/globals.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/pages/paymentAlert.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:black_history_calender/services/auth_services.dart';
import 'package:black_history_calender/widget/payment_not_found_dialog.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreenFromHomeAndroid extends StatefulWidget {
  const SubscriptionScreenFromHomeAndroid({Key key}) : super(key: key);

  @override
  _SubscriptionScreenFromHomeAndroidState createState() => _SubscriptionScreenFromHomeAndroidState();
}

class _SubscriptionScreenFromHomeAndroidState extends State<SubscriptionScreenFromHomeAndroid> {
  final TextEditingController promoController = TextEditingController();
  String packageSelection = "Monthly";
  String token;
  String userID;
  bool packageSelectionMonthly = true;
  final AuthBase auth = Auth();
  var amount = '3.99';
  var discountedAmount = '3.99';
  String email = "";
  String userName = "";
  String membership = "";

  @override
  void initState() {
    super.initState();
    initData();
  }

  status() async {
    try {
      http.Response response = await http.get(Uri.parse('https://myblackhistorycalendar.com/wp-json/wcra/v1/checkmembership/?secret_key=Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0&user_id=$id'));
      final responseBody = Map<String, dynamic>.from(jsonDecode(response.body));
      if (responseBody["data"].toString() == '0') {
        EasyLoading.dismiss();
        paymentNotFound(context);
      } else {
        Prefs.setMembership(responseBody["data"].toString());
        EasyLoading.dismiss();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
          ModalRoute.withName('/'),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  initData() async {
    await Prefs.token.then((value) => setState(() {
          token = value;
        }));
    await Prefs.id.then((value) => setState(() {
          userID = value;
        }));
    await Prefs.membership.then((value) => setState(() {
          packageSelection = value;
          membership = value;
        }));
    await Prefs.email.then((value) => setState(() {
          email = value;
        }));
    await Prefs.userName.then((value) => setState(() {
          userName = value;
        }));

    setState(() {
      packageSelection = "Monthly";
      amount = '3.99';
      discountedAmount = '3.99';
    });
  }

  checkPayment(context) {
    Future.delayed(const Duration(seconds: 2), () {
      showPaymentAlert(context, status);
    });
  }

  Future<bool> checkPromo(code, id) async {
    try {
      EasyLoading.show(dismissOnTap: false);
      var response = await http.post(
        Uri.parse("https://myblackhistorycalendar.com/wp-json/wcra/v1/get_promo/?secret_key=Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0&code=$code&level_id=$id"),
      );
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        if (body['data'].isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid Promo Code'),
            ),
          );
          return false;
        } else {
          setState(() {
            amount = body['data'][0]['billing_amount'];
            discountedAmount = body['data'][0]['initial_payment'];
            print("discountedAmount $discountedAmount");
          });
          print(body['data'][0]);
          return true;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error validating Promo Code'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 100, right: 20, left: 20),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error validating Promo Code'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 100, right: 20, left: 20),
        ),
      );
      print(e);

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(gradient: backGradient2),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0xff0a83bf),
          elevation: 0.0,
          automaticallyImplyLeading: true,
          title: Text(
            'Select a Subscription Plan',
            style: GoogleFonts.montserrat(color: white, fontSize: 22, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(gradient: backGradient2),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 80,
                width: 80,
                child: Center(
                  child: Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/bhc_logo.png',
                            ),
                            fit: BoxFit.contain)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  '365 Days of Black History',
                  style: GoogleFonts.montserrat(color: white, fontSize: 25, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Daily updates, unlimited stories\npersonal insights and much more',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(color: white, fontSize: 13, height: 1.5, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              packageSelection = "Monthly";
                              packageSelectionMonthly = true;
                              amount = "3.99";
                            });
                          },
                          child: Card(
                            elevation: packageSelection.contains("Monthly") ? 15 : 0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  // width: 115,
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: packageSelection.contains("Monthly") ? Color(0xff1ABFDD) : white,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '1\nMONTH',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '\$7.99',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(color: Colors.black, decoration: TextDecoration.lineThrough, fontSize: 16, fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              '\$3.99',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              '',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              height: 5,
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
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        height: 130,
                        width: 130,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              packageSelection = "Annually";
                              packageSelectionMonthly = false;
                              amount = "24.99";
                            });
                          },
                          child: Card(
                            elevation: packageSelection.contains("Annually") ? 15 : 0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  // width: 130,

                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: packageSelection.contains("Annually") ? Color(0xff1ABFDD) : white,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                              // topLeft: Radius.circular(8),
                                              // topRight: Radius.circular(8)
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                '12\nMONTHS',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '\$49.99',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(color: Colors.black, fontSize: 16, decoration: TextDecoration.lineThrough, fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              '\$24.99',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              'Save upto 75%',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: -20,
                                    left: 20,
                                    right: 20,
                                    child: Card(
                                      elevation: 4,
                                      color: Color(0xff0891d9),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Container(
                                        height: 25,
                                        decoration: BoxDecoration(),
                                        child: Center(
                                          child: Text(
                                            'Saver',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(color: white, fontSize: 12, fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 130,
                  width: 130,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        packageSelection = "lifeTime";
                        amount = "149.99";
                        packageSelectionMonthly = false;
                      });
                    },
                    child: Card(
                      elevation: packageSelection.contains("lifeTime") ? 15 : 0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            // width: 100,100
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: packageSelection.contains("lifeTime") ? Color(0xff1ABFDD) : white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Life\nTime',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$299.99',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(color: Colors.black, decoration: TextDecoration.lineThrough, fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        '\$149.99',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        'Get Started Now!',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              top: -20,
                              left: 20,
                              right: 20,
                              child: Card(
                                elevation: 4,
                                color: Colors.deepOrangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Container(
                                  height: 25,
                                  decoration: BoxDecoration(),
                                  child: Center(
                                    child: Text(
                                      'Best Value',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(color: white, fontSize: 12, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        textCapitalization: TextCapitalization.characters,
                        controller: promoController,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: false,
                          hintText: "Enter Code Here...",
                          hintStyle: GoogleFonts.montserrat(fontSize: 18, letterSpacing: 1, color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      height: 40,
                      decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1))),
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Center(
                        child: Text(
                          'PROMO',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(color: Colors.grey.withOpacity(0.5), fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  if (promoController.text.trim() != "") {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    if (await checkPromo(
                      promoController.text.trim(),
                      packageSelection.contains("lifeTime")
                          ? 4
                          : packageSelection.contains("Annually")
                              ? 2
                              : 1,
                    )) {
                      var url =
                          'https://myblackhistorycalendar.com/membership-account/membership-checkout/?level=${packageSelection.contains("lifeTime") ? "4" : packageSelection.contains("Annually") ? "2" : "1"}&username=$userID&discount_code=${promoController.text.trim()}';
                      if (membership != '0') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Note: Please cancel your current subscription first!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else {
                        launch(url);
                        checkPayment(context);
                      }
                    }
                  } else {
                    setState(() {
                      discountedAmount = amount;
                    });
                    var url = 'https://myblackhistorycalendar.com/membership-account/membership-checkout/?level=${packageSelection.contains("lifeTime") ? "4" : packageSelection.contains("Annually") ? "2" : "1"}&username=$userID';
                    if (membership == '1' || membership == '2' || membership == '3' || membership == '4') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Note: Please cancel your current subscription first!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      launch(url);
                      checkPayment(context);
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'CONTINUE',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(color: Color(0xff1d92d0), fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future subscribePackage() async {
    EasyLoading.show(dismissOnTap: false);
    var response = await Provider.of<AuthProvider>(context, listen: false).makeSubscription(packageSelection, userID, token);

    if (response.statusCode == 200) {
      packageSelection.contains("yearly") ? Prefs.setMembership("Annually") : Prefs.setMembership("Monthly");

      EasyLoading.dismiss();

      Navigator.pop(context);
    } else {
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Something went wrong");
    }
  }
}
