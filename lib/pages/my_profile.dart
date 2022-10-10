import 'dart:convert';
import 'dart:io';

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/pages/cancelAlert.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/story/upload_media_response.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/mydialog.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String name = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String userlogin = '';
  String membership = '';
  String dob = '';
  String imgurl = '';
  DateTime _datetime;
  File image;
  String token;
  String id = '';
  String renewalDate = "";
  DateTime _chosenDateTime;

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
            height: 500,
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Done",
                      style: GoogleFonts.montserrat(fontSize: 18),
                    )),
                Container(
                  height: 400,
                  child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      maximumDate: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (val) {
                        setState(() {
                          _chosenDateTime = val;
                        });
                      }),
                ),
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  _getFromGallery() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile imagePick = await _picker.pickImage(source: ImageSource.gallery);
      if (imagePick == null) return;
      setState(() {
        final imageTemperory = File(imagePick.path);
        image = imageTemperory;
      });
      print("11111111111");
      UploadMediaResponse res = await uploadMedia(image, token);
      if (res != null) {
        String imgg = res.id.toString();
        imgurl = res.guid.toString();
        EasyLoading.show(dismissOnTap: false);

        String id = '';
        await Prefs.id.then((value) => setState(() {
              id = value;
            }));
        EasyLoading.show(dismissOnTap: false);
        var response = await Provider.of<AuthProvider>(context, listen: false).updateImgApi(id, imgg);

        if (response != null) {
          Prefs.setImg(imgurl);
          EasyLoading.dismiss();
          CommonWidgets.buildSnackbar(context, "Profile Pic updated");
        } else {
          EasyLoading.dismiss();
          CommonWidgets.buildSnackbar(context, "Something went wrong");
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Something went wrong");
      print(e);
    }
  }

  initData() async {
    EasyLoading.show();

    await Prefs.token.then((value) => setState(() {
          token = value;
        }));
    await Prefs.id.then((value) => setState(() {
          id = value;
        }));

    await Prefs.imgurl.then((value) => setState(() {
          imgurl = value;
        }));

    await Prefs.name.then(
      (value) => setState(() {
        name = value;
      }),
    );
    await Prefs.firstName.then(
      (value) => setState(() {
        firstName = value;
      }),
    );

    await Prefs.userLogin.then(
      (value) => setState(() {
        userlogin = value;
      }),
    );
    await Prefs.lastName.then(
      (value) => setState(() {
        lastName = value;
      }),
    );
    await Prefs.email.then(
      (value) => setState(() {
        email = value;
      }),
    );
    await Prefs.membership.then(
      (value) => setState(() {
        membership = value;
      }),
    );

    await Prefs.dob.then(
      (value) => setState(() {
        dob = value;
      }),
    );

    if (Platform.isIOS) {
      try {
        if (await Prefs.membership != '0') {
          List<PurchasedItem> purchases = await FlutterInappPurchase.instance.getAvailablePurchases();
          print(FirebaseAuth.instance.currentUser.displayName);
          for (int i = 0; i < purchases.length; i++) {
            print(purchases[i].originalTransactionDateIOS);
            print(purchases[i].transactionStateIOS);
          }
          print(purchases.last.productId);
          if (await Prefs.membership == '1') {
            setState(() {
              renewalDate = DateTime(purchases.last.originalTransactionDateIOS.year, purchases.last.originalTransactionDateIOS.month + 1,
                      purchases.last.originalTransactionDateIOS.day)
                  .toString()
                  .split(' ')[0];
            });
          } else if (await Prefs.membership == '2') {
            setState(() {
              renewalDate = DateTime(purchases.last.originalTransactionDateIOS.year + 1, purchases.last.originalTransactionDateIOS.month,
                      purchases.last.originalTransactionDateIOS.day)
                  .toString()
                  .split(' ')[0];
            });
          } else if (await Prefs.membership == '3') {
            setState(() {
              renewalDate = 'You have Lifetime subscriptions';
            });
          }
        }
      } catch (e) {
        print(e);
        EasyLoading.dismiss();
      }
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: lightBlue,
          elevation: 0.0,
          title: Text('Account Details'),
          centerTitle: true,
          actions: [],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: lightBlue,
                  height: 150,
                  width: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _getFromGallery();
                          },
                          child: CircleAvatar(
                            radius: 50,
                            child: ClipOval(
                              child: imgurl == "" || imgurl == null
                                  ? SizedBox()
                                  : Image.network(
                                      imgurl,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          name,
                          style: GoogleFonts.montserrat(color: white, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "First Name:  ${firstName.toString().substring(0, 1).toUpperCase()}${firstName.toString().substring(1).toLowerCase()}",
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          "Last Name:  ${lastName.toString().substring(0, 1).toUpperCase()}${lastName.toString().substring(1).toLowerCase()}",
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          "Email:  $email",
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Membership Plan: ${membership == '1' ? "1 Month" : membership == '2' ? '12 Months' : membership == '4' ? 'Life Time' : 'No Membership'}",
                              style: GoogleFonts.montserrat(),
                            ),
                            Platform.isAndroid
                                ? GestureDetector(
                                    onTap: () async {
                                      await cancelAlert(context, cancelSubscription);
                                    },
                                    child: membership != "0"
                                        ? Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.montserrat(color: Colors.white),
                                            ),
                                          )
                                        : SizedBox(),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      membership == '0' || Platform.isAndroid ? SizedBox() : Divider(),
                      membership == '0' || Platform.isAndroid
                          ? SizedBox()
                          : ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Renewal Date: $renewalDate",
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ],
                              ),
                            ),
                      Divider(),
                      ListTile(
                        title: Text(
                          dob.isNotEmpty
                              ? "Date of Birth: $dob"
                              : _chosenDateTime != null
                                  ? "Date of Birth: ${DateFormat("dd - MM - y").format(_chosenDateTime)}"
                                  : "Date of Birth: Select Dob",
                          style: GoogleFonts.montserrat(),
                        ),
                        onTap: () {
                          _showDatePicker(context);
                        },
                      ),
                      TextButton(
                        child: Text("Update Date Of Birth"),
                        onPressed: () {
                          updateDob(DateFormat("dd-MM-y").format(_chosenDateTime));
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    var text = "";
                    if (membership == '0') {
                      text = "Your account will be permanently deleted!";
                    } else if (membership == '1') {
                      text = "Your monthly subscription is valid till $renewalDate.Please cancel your subscription before deleting your account.";
                    } else if (membership == '2') {
                      text = "Your annual subscription is valid till $renewalDate.Please cancel your subscription before deleting your account.";
                    } else if (membership == '4') {
                      text = "You have purchased lifetime subscription, by deleting your account you will lose your subscription!";
                    }
                    showDeleteAccountAlert(context, text, id);
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
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            'DELETE ACCOUNT',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ));
  }

  Future updateDob(String dob) async {
    String id = '';
    await Prefs.id.then((value) => setState(() {
          id = value;
        }));
    EasyLoading.show(dismissOnTap: false);
    var response = await Provider.of<AuthProvider>(context, listen: false).updateDobApi(id, dob);

    if (response != null) {
      Prefs.setDob(dob);
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Dob updated");
    } else {
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Something went wrong");
    }
  }

  Future<UploadMediaResponse> uploadMedia(File filePath, token) async {
    EasyLoading.show();
    var response;
    try {
      UploadMediaResponse uploadMediaResponse;
      String url = 'https://myblackhistorycalendar.com/wp-json/wp/v2/media';

      String fileName = filePath.path.split('/').last;

      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
        'Content-Disposition': 'attachment; filename=$fileName',
        'Content-Type': 'image/*'
      };

      List<int> imageBytes = File(filePath.path).readAsBytesSync();
      var request = http.Request('POST', Uri.parse(url));
      request.headers.addAll(requestHeaders);
      request.bodyBytes = imageBytes;
      var res = await request.send();

      var convertedDataJson = await res.stream.bytesToString();
      response = jsonDecode(convertedDataJson);
      // debugPrint("$response");
    } catch (e) {
      debugPrint("Error in upload media $e");
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Server Down");
      return null;
    }
    return UploadMediaResponse.fromJson(response as Map<String, dynamic>);
  }

  cancelSubscription() async {
    try {
      EasyLoading.show();
      var response = await http.post(
          Uri.parse("https://myblackhistorycalendar.com/wp-json/pmpro/v1/cancel_membership_level?user_id=$id&level_id=$membership"),
          headers: {"content-type": "application/json", 'Authorization': 'Bearer ' + token});
      if (response.body == 'true') {
        await Prefs.setMembership("0");
        setState(() {
          membership = "0";
        });
        EasyLoading.dismiss();
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    }
  }
}
