import 'dart:io';

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/network_module/api_response.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:black_history_calender/services/auth_services.dart';
import 'package:black_history_calender/services/payment_service.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {


  const SubscriptionScreen({Key key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String packageSelection = "";
  bool packageSelectionMonthly =true;
  String token;
  String userID;
  List<IAPItem> iapProducts;
  final AuthBase auth = Auth();
  @override
  void initState() {
    super.initState();
    initData();
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
        }));

    // await Prefs.subsRole.then((value) => setState(() {
    //       if (value.isNotEmpty) {
    //         packageSelection = value;
    //       } else {
    //         packageSelection = "Yearly";
    //       }
    //     }));

    PaymentService.instance.addToProStatusChangedListeners(() async {
      print("Success: ");
      await subscribePackage();
    });
    PaymentService.instance.addToErrorListeners((value) {
      print("Error: " + value.toString());
    });

    var res = await PaymentService.instance.products;

    setState(() {
      iapProducts = res;
    });
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          // leading: GestureDetector(
          //     onTap: () {
          //       // if (Platform.isAndroid) {
          //       //   SystemNavigator.pop();
          //       // } else if (Platform.isIOS) {
          //       //   exit(0);
          //       // }
          //       // Navigator.pop(context);
          //     },
          //     child: Icon(
          //       Icons.arrow_back_ios,
          //       color: white,
          //       size: 20,
          //     )),
          // title: Text(
          //   'Subscription',
          //   style: GoogleFonts.montserrat(
          //       color: white,
          //       fontSize: 20,
          //       fontWeight: FontWeight.w500),
          // ),
          actions: [
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomeScreen(auth: auth,)));
              },
              child: Padding(
                padding:  EdgeInsets.all(15),
                child: Text(
                  'Skip',
                  style: GoogleFonts.montserrat(
                      color: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(gradient: backGradient2),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Select A Subscription Plan',
                  style: GoogleFonts.montserrat(
                      color: white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400),
                ),
              ),
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
                    // child: Image.asset(
                    //   'assets/images/bhc_logo.png',
                    //   height: 100,
                    //   width: 100,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  '365 Days of Black History',
                  style: GoogleFonts.montserrat(
                      color: white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Daily updates, unlimited stories\npersonal insights and much more',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: white,
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       packageSelection = "Monthly";
                      //     });
                      //   },
                      //   child: Card(
                      //     elevation:
                      //         packageSelection.contains("Monthly") ? 15 : 0,
                      //     child: Container(
                      //       width: 115,
                      //       height: MediaQuery.of(context).size.height,
                      //       decoration: BoxDecoration(
                      //           color: white,
                      //           borderRadius: BorderRadius.circular(8)),
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Expanded(
                      //             child: Padding(
                      //               padding: const EdgeInsets.symmetric(
                      //                   vertical: 18.0),
                      //               child: Text(
                      //                 '1\nMONTH',
                      //                 textAlign: TextAlign.center,
                      //                 style: GoogleFonts.montserrat(
                      //                     color: Colors.grey,
                      //                     fontSize: 17,
                      //                     fontWeight: FontWeight.w400),
                      //               ),
                      //             ),
                      //           ),
                      //           Expanded(
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.end,
                      //               children: [
                      //                 Text(
                      //                   '\$25.99',
                      //                   textAlign: TextAlign.center,
                      //                   style: GoogleFonts.montserrat(
                      //                       color: Colors.grey,
                      //                       fontSize: 25,
                      //                       fontWeight: FontWeight.w400),
                      //                 ),
                      //                 Text(
                      //                   '',
                      //                   textAlign: TextAlign.center,
                      //                   style: GoogleFonts.montserrat(
                      //                       color: Colors.grey,
                      //                       fontSize: 12,
                      //                       fontWeight: FontWeight.w700),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 10,
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            packageSelection = "Monthly";
                            packageSelectionMonthly=true;
                          });
                        },
                        child: Card(
                          elevation:
                              packageSelection.contains("Monthly") ? 15 : 0,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 115,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: packageSelection
                                                  .contains("Monthly")
                                              ? Color(0xff1ABFDD)
                                              : white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                            // topLeft: Radius.circular(6),
                                            // topRight: Radius.circular(6)
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18.0),
                                          child: Text(
                                            '1\nMONTH',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$4.99',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            '',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Positioned(
                              //     top: -20,
                              //     left: 20,
                              //     right: 20,
                              //     child: Card(
                              //       elevation: 4,
                              //       color: Color(0xff0891d9),
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(8.0),
                              //       ),
                              //       child: Container(
                              //         height: 25,
                              //         decoration: BoxDecoration(),
                              //         child: Center(
                              //           child: Text(
                              //             'SAVE 18%',
                              //             textAlign: TextAlign.center,
                              //             style: GoogleFonts.montserrat(
                              //                 color: white,
                              //                 fontSize: 10,
                              //                 fontWeight: FontWeight.w400),
                              //           ),
                              //         ),
                              //       ),
                              //     )),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 20,
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            packageSelection = "Annually";
                            packageSelectionMonthly=false;
                          });
                        },
                        child: Card(
                          elevation:
                              packageSelection.contains("Annually") ? 15 : 0,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 115,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: packageSelection
                                                  .contains("Annually")
                                              ? Color(0xff1ABFDD)
                                              : white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                            // topLeft: Radius.circular(8),
                                            // topRight: Radius.circular(8)
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 18.0),
                                          child: Text(
                                            '12\nMONTHS',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black87,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$40',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            'Save \$20',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 10,
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
                                          'SAVE 18%',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                              color: white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
            /*  Text(
                'Include 7-day f, cancel before\nSeptember 30, and nothing will be billed',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: white,
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w400),
              ), */
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () async {
                  // var res = await FlutterInappPurchase.instance
                  //     .getSubscriptions(["bhc_monthly_sub"]);

                  // print(res);

                  // IAPItem inAppItem =
                  //     IAPItem.fromJSON({"productId": "bhc_monthly_subb"});

                  // PaymentService.instance.buyProduct(inAppItem);
                  List<IAPItem> prod = await PaymentService.instance.products;
                 if(packageSelectionMonthly){
                   PaymentService.instance.buyProduct(prod[0]);
                 }
                 else
                   PaymentService.instance.buyProduct(prod[1]);
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
                          style: GoogleFonts.montserrat(
                              color: Color(0xff1d92d0),
                              fontSize: 18,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w400),
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
    var response = await Provider.of<AuthProvider>(context, listen: false)
        .makeSubscription(packageSelection, userID, token);

    if (response.statusCode == 200) {
      packageSelection.contains("yearly")
          ? Prefs.setMembership("Annually")
          : Prefs.setMembership("Monthly");

      EasyLoading.dismiss();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen(auth: auth,)));

      // CommonWidgets.buildSnackbar(context, "Sign In successful");
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => SubscriptionScreen()),
      //     ModalRoute.withName('/'));
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => SubscriptionScreen()),
      //     (Route<dynamic> route) => false);
    } else {
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Something went wrong");
    }
  }
}
