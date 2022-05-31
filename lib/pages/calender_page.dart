import 'package:black_history_calender/components/mydialog.dart';
import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/screens/auth/model/newstories_response.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detail_screen.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({Key key}) : super(key: key);

  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  String dob = '';
  DateTime startDate;
  DateTime endDate;

  // Show the modal that contains the CupertinoDatePicker
  void _showDatePicker(BuildContext context) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        // barrierDismissible: false,
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
                      "Confirm",
                      style: GoogleFonts.montserrat(fontSize: 18),
                    )),
                Container(
                  height: 400,
                  child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      maximumDate: DateTime.now(),
                      minimumYear: 2021,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (val) {
                        setState(() {
                          startDate = val;
                        });
                      }),
                ),
              ],
            )));
  }

  void _showDatePickerr(BuildContext context) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        // barrierDismissible: false,
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
                      "Confirm",
                      style: GoogleFonts.montserrat(fontSize: 18),
                    )),
                Container(
                  height: 400,
                  child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      maximumDate: DateTime.now(),
                      minimumYear: 2021,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (val) {
                        setState(() {
                          endDate = val;
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

  initData() async {
    setState(() {
      startDate = DateTime.parse(dob);
      endDate = DateTime.parse(dob);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                pageController.jumpToPage(0);
              },
              icon: Icon(Icons.navigate_before)),
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          //  decoration: BoxDecoration(gradient: backGradient),
          //  height: MediaQuery.of(context).size.height,
          //  width: MediaQuery.of(context).size.width,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            //  mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: lightBlue,
                height: 280,
                width: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
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
              Divider(),
              ListTile(
                leading: Image.asset(
                  "assets/images/membership.png",
                  height: 28,
                  width: 28,
                  fit: BoxFit.fill,
                ),
                title: Text(
                  dob.isNotEmpty
                      ? dob
                      : startDate != null
                          ? DateFormat("dd-MM-y").format(startDate)
                          : "Select Start Date",
                  style: GoogleFonts.montserrat(),
                ),
                onTap: () {
                  _showDatePicker(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Image.asset(
                  "assets/images/membership.png",
                  height: 28,
                  width: 28,
                  fit: BoxFit.fill,
                ),
                title: Text(
                  dob.isNotEmpty
                      ? dob
                      : endDate != null
                          ? DateFormat("dd-MM-y").format(endDate)
                          : "Select End Date",
                  style: GoogleFonts.montserrat(),
                ),
                onTap: () {
                  _showDatePickerr(context);
                },
              ),
              TextButton(
                style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
                onPressed: () {
                  String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
                  String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchList(formattedStartDate, formattedEndDate)));
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xff0891d9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Search Now',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(color: white, fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),

              /*    Text(
                "Select a range",
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 10,
                                  offset: Offset(0, 0), // Shadow position
                                ),
                              ]),
                          child: SfDateRangePicker(
                            initialSelectedDate: DateTime.now(),
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs date) {
                              startDate = date.value.startDate as DateTime;
                              endDate = date.value.endDate as DateTime;
                            },
                            selectionMode: DateRangePickerSelectionMode.range,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          String formattedStartDate =
                              DateFormat('yyyy-MM-dd').format(startDate);
                          String formattedEndDate =
                              DateFormat('yyyy-MM-dd').format(endDate);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchList(
                                      formattedStartDate, formattedEndDate)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: lightBlue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                'Search',
                                style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ), */
            ],
          ),
        ));
  }
}

class SearchList extends StatefulWidget {
  String startDate;
  String endDate;

  SearchList(this.startDate, this.endDate);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  var updatedlike;
  int currentPage = 1;

  int totalPages = 1000;

  List<StoryData> passengers = [];

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<bool> getPassengerData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
    } else {
      if (currentPage >= totalPages) {
        refreshController.loadNoData();
        return false;
      }
    }

    List<StoryData> response = await AuthProvider().calendarsearch(widget.startDate, widget.endDate, currentPage);

    if (isRefresh) {
      passengers = response;
    } else {
      passengers.addAll(response);
    }

    currentPage++;

    setState(() {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: lightBlue,
          ),
          body: SmartRefresher(
            controller: refreshController,
            enablePullUp: true,
            onRefresh: () async {
              final result = await getPassengerData(isRefresh: true);
              if (result) {
                refreshController.refreshCompleted();
              } else {
                refreshController.refreshFailed();
              }
            },
            onLoading: () async {
              final result = await getPassengerData();
              if (result) {
                refreshController.loadComplete();
              } else {
                refreshController.loadFailed();
              }
            },
            child: ListView.builder(
                itemCount: passengers.length,
                itemBuilder: (context, index) {
                  final user = passengers[index];
                  var htmldata = parse(user.postContent);
                  var myList = htmldata.getElementsByTagName('p');
                  String parsedData;
                  if (myList.isNotEmpty) {
                    parsedData = myList[2].innerHtml;
                  } else {
                    parsedData = user.postContent;
                  }
                  var audioHtml = htmldata.getElementsByTagName('audio');

                  var audio = audioHtml.length > 0 ? audioHtml[0].attributes['src'] : '';
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        // if (await FlutterInappPurchase
                        //     .instance
                        //     .checkSubscribed(
                        //   sku: "bhc_monthly_subb",
                        // ))
                        var mem = await Prefs.membership;

                        if (mem != '0') {
                          CommonWidgets.buildSnackbar(context, "subscribed");
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(passengers[index], false, audio, false)))
                              .then((value) => setState(() {}));
                        }
                        // else if (await FlutterInappPurchase
                        //      .instance
                        //      .checkSubscribed(
                        //    sku: "bhc_yearly_subb",
                        //  ))
                        // {
                        //    print("subscribed");
                        //    CommonWidgets
                        //        .buildSnackbar(
                        //        context,
                        //        "subscribed");
                        //    Navigator.push(
                        //        context,
                        //        MaterialPageRoute(
                        //            builder: (context) =>
                        //                DetailScreen(
                        //                    passengers[
                        //                    index],
                        //                    false,
                        //                    audio,false))).then(
                        //            (value) => setState(
                        //                () {}));
                        //  }
                        else
                          showAlert(context);
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  color: Colors.black45,
                                  fit: BoxFit.cover,
                                  imageUrl: user.featuredMediaSrcUrl,
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: 80.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.photo_library,
                                    size: 50,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              user.postTitle,
                                              style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              EasyLoading.show(dismissOnTap: false);
                                              AuthProvider().addfavourite(user.id, 1).then((value) {
                                                setState(() {
                                                  user.isFavourite = user.isFavourite.contains("1") ? "0" : "1";
                                                });
                                                EasyLoading.dismiss();
                                                CommonWidgets.buildSnackbar(
                                                    context, user.isFavourite == "1" ? 'Added in Favourite stories' : 'Removed Favourite stories');
                                              });
                                            },
                                            child: Icon(
                                              user.isFavourite == "1" ? Icons.favorite : Icons.favorite_border_outlined,
                                              color: user.isFavourite == "1" ? Colors.red : Colors.grey,
                                              size: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Expanded(
                                          child: Html(
                                        data: parsedData,
                                        onLinkTap: (url, _, __, ___) {
                                          launch(url);
                                        },
                                        onImageTap: (src, _, __, ___) {
                                          launch(src);
                                        },
                                      )

                                          //     Text(
                                          //   user.excerpt.rendered,
                                          //   overflow: TextOverflow
                                          //       .ellipsis,
                                          //   maxLines: 3,
                                          //   style: GoogleFonts
                                          //       .montserrat(
                                          //           fontSize: 10,
                                          //           color: Color(
                                          //               0xff818181)),
                                          // )),
                                          ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.access_time,
                                                  color: lightBlue,
                                                  size: 15,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  DateFormat.yMMMd().format(user.postDate),
                                                  style: GoogleFonts.montserrat(color: lightBlue, fontWeight: FontWeight.w300, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            // onTap: () {
                                            //   setState(() {
                                            //     updatedlike++;
                                            //   });
                                            //   AuthProvider()
                                            //       .postlike(
                                            //           user.id,
                                            //           updatedlike)
                                            //       .then((value) =>
                                            //           setState(
                                            //               () {}));
                                            // },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text(
                                                    user.likes,
                                                    style:
                                                        GoogleFonts.montserrat(color: Color(0xff999999), fontWeight: FontWeight.w600, fontSize: 13),
                                                  ),
                                                ),
                                                Image.asset(
                                                  "assets/images/like_thumb.png",
                                                  height: 15,
                                                  width: 15,
                                                  // fit: BoxFit.contain,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text(
                                                    user.commentCount,
                                                    style:
                                                        GoogleFonts.montserrat(color: Color(0xff999999), fontWeight: FontWeight.w600, fontSize: 13),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Image.asset(
                                                    "assets/images/comment.png",
                                                    height: 17,
                                                    width: 17,
                                                    color: Colors.blue,
                                                    // fit: BoxFit.contain,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )),
    );
  }
}

// Widget _SearchList(BuildContext context,var From,var Until) {
//
//  return
// }
