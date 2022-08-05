import 'dart:async';
import 'dart:io';

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/network_module/api_response.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:black_history_calender/services/payment_service.dart';
import 'package:black_history_calender/widget/privacyPolicy.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SubscriptionScreenFromHome extends StatefulWidget {
  const SubscriptionScreenFromHome({Key key}) : super(key: key);

  @override
  _SubscriptionScreenFromHomeState createState() =>
      _SubscriptionScreenFromHomeState();
}

class _SubscriptionScreenFromHomeState
    extends State<SubscriptionScreenFromHome> {
  String packageSelection = "";
  String token;
  String userID;
  List<IAPItem> iapProducts;
  var amount = '7.99';
  var discountedAmount = '7.99';
  String email = "";
  String userName = "";
  String membership = "";
  bool packageSelectionMonthly = true;

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  @override
  void initState() {
    super.initState();
    initData();
    initPlatformState();
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

    var res = await PaymentService.instance.products;

    setState(() {
      iapProducts = res;
      packageSelection = "Monthly";
      amount = '7.99';
      discountedAmount = '7.99';
    });
  }

  Future updateMembership(levelId) async {
    Map<String, String> body = Map<String, String>();
    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };
    var uri =
        "https://myblackhistorycalendar.com/wp-json/pmpro/v1/change_membership_level?user_id=$userID&level_id=$levelId";
    final response =
        await http.post(Uri.parse(uri), body: body, headers: header);
    if (response.statusCode == 200) {
      if (response.body == 'true') {
        Prefs.setMembership(levelId);
        EasyLoading.dismiss();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),
          ModalRoute.withName('/'),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Purchase Error:  ${response.statusCode} ${response.body}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> initPlatformState() async {
    await FlutterInappPurchase.instance.initialize();
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) async {
      print('purchase-updated: $productItem');
      EasyLoading.show();

      if (Platform.isIOS) {
        if (productItem.productId != 'lifetime_subs') {
          var receiptBody = {
            'receipt-data': productItem.transactionReceipt,
            'password': '3c85e4c2211343f88ff89a67cc616ef1'
          };

          var result = await FlutterInappPurchase.instance
              .validateReceiptIos(receiptBody: receiptBody, isTest: false);
          print("result :${result.body}");
        }
        await FlutterInappPurchase.instance
            .finishTransactionIOS(productItem.transactionId);
      } else {
        var result = await FlutterInappPurchase.instance
            .acknowledgePurchaseAndroid(productItem.purchaseToken);
        print("result acknowledgePurchaseAndroid: ${result}");
      }

      if (await Prefs.membership == '0') {
        if (Platform.isIOS) {
          if (productItem.productId == 'monthly_subs') {
            await updateMembership('1');
          } else if (productItem.productId == 'yearly_subs') {
            await updateMembership('2');
          } else if (productItem.productId == 'lifetime_subs') {
            await updateMembership('4');
          }
        }
      }

      // try{

      //   FlutterInappPurchase.instance.validateReceiptAndroid(packageName: 'com.protech.myblackhistorycalendar', productId: productItem.productId, productToken: productItem.purchaseToken, accessToken: accessToken,isSubscription: true);
      //   final response = await http.post(Uri.parse(
      //       'https://androidpublisher.googleapis.com/androidpublisher/v3/applications/com.protech.myblackhistorycalendar/purchases/subscriptions/${productItem.productId}/tokens/${productItem.purchaseToken}:acknowledge'));
      //   if (response.statusCode == 200) {
      //     print(response.body);
      //   }
      // }catch(e){
      //   print("response $e");
      // }
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchase Error:  ${purchaseError.message}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  void dispose() {
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      _conectionSubscription = null;
    }
    super.dispose();
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
            style: GoogleFonts.montserrat(
                color: white, fontSize: 22, fontWeight: FontWeight.w400),
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
                  style: GoogleFonts.montserrat(
                      color: white, fontSize: 25, fontWeight: FontWeight.w400),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                              amount = "7.99";
                            });
                          },
                          child: Card(
                            elevation:
                                packageSelection.contains("Monthly") ? 15 : 0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  // width: 115,
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
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
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
                                              '\$7.99',
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
                              amount = "49.99";
                            });
                          },
                          child: Card(
                            elevation:
                                packageSelection.contains("Annually") ? 15 : 0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  // width: 130,

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
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
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
                                              '\$49.99',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              'Save upto 50%',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.grey,
                                                  fontSize: 10,
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Container(
                                        height: 25,
                                        decoration: BoxDecoration(),
                                        child: Center(
                                          child: Text(
                                            'Saver',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.montserrat(
                                                color: white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400),
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
                        amount = "299";
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
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color:
                                          packageSelection.contains("lifeTime")
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
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Text(
                                        'Life\nTime',
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$299',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        'Get Started Now!',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.grey,
                                            fontSize: 10,
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
                                      style: GoogleFonts.montserrat(
                                          color: white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
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
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  if (userID == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please Sign in to your account first'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else if (membership != '0') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Note: Please cancel your current subscription first!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    EasyLoading.show();
                    List<IAPItem> _iaps = [];
                    String selectedItem = 'monthly_subs';
                    _initIAPs() async {
                      _iaps.clear();
                      var result =
                          await FlutterInappPurchase.instance.initialize();
                      print("Established IAP Connection..." + result);
                      if (Platform.isAndroid) {
                        _iaps = await FlutterInappPurchase.instance
                            .getSubscriptions(
                                ["bhc_monthly_subb", "bhc_yearly_subb"]);
                      } else {
                        if (packageSelection == "lifeTime") {
                          selectedItem = 'lifetime_subs';
                          print("lifeTime-------------$selectedItem");
                        } else if (packageSelection == "Annually") {
                          selectedItem = 'yearly_subs';
                          print("Annually-------------$selectedItem");
                        }
                        if (_iaps.length > 0) {
                          _iaps.removeAt(0);
                        }
                        _iaps = await FlutterInappPurchase.instance
                            .getSubscriptions([selectedItem]);
                      }
                      print(_iaps.length);
                      for (var i = 0; i < _iaps.length; i++) {
                        print(_iaps[i].title + " " + _iaps[i].price);
                      }
                    }

                    await _initIAPs();
                    EasyLoading.dismiss();
                    try {
                      PaymentService.instance.buyProduct(_iaps
                          .where((element) => element.productId == selectedItem)
                          .first);
                    } catch (e) {
                      PlatformException p = e as PlatformException;
                      print(p.code);
                      print(p.message);
                      print(p.details);
                      print(e);
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
                height: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (userID == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please sign in to your account first'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else if (membership != '0') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You are already subscribed!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      try {
                        List<PurchasedItem> purchases =
                            await FlutterInappPurchase.instance
                                .getAvailablePurchases();
                        if (purchases.last.productId == 'lifetime_subs') {
                          await Prefs.setMembership('4');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Your lifetime subscription has been restored!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else if (await FlutterInappPurchase.instance
                            .checkSubscribed(
                                sku: 'yearly_subs',
                                duration: Duration(days: 365),
                                grace: Duration(days: 7))) {
                          await Prefs.setMembership('2');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Your yearly subscription has been restored!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else if (await FlutterInappPurchase.instance
                            .checkSubscribed(
                                sku: 'monthly_subs',
                                duration: Duration(days: 30),
                                grace: Duration(days: 7))) {
                          await Prefs.setMembership('1');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Your monthly subscription has been restored!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          await Prefs.setMembership('0');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Your don't have any active subscription!"),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (e) {
                        print("error in getPurchaseHistory: $e");
                      }
                    }
                  },
                  child: Text(
                    "RESTORE PURCHASE",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicy(
                                      url:
                                          'https://myblackhistorycalendar.com/terms-conditions/',
                                    )));
                      },
                      child: Text(
                        "Terms & Conditions",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Text(
                      " and ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w300),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicy(
                                      url:
                                          'https://myblackhistorycalendar.com/privacy-policy/',
                                    )));
                      },
                      child: Text(
                        "Privacy Policy.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
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
}
