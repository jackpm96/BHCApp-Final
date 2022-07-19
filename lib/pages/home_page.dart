import 'dart:ui';

import 'package:black_history_calender/components/mydialog.dart';
import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/network_module/api_response.dart';
import 'package:black_history_calender/pages/seemore_page.dart';
import 'package:black_history_calender/screens/auth/model/newstories_response.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List images = [
    'assets/images/a1.png',
    'assets/images/a2.png',
    'assets/images/a3.png',
    'assets/images/a4.png',
    'assets/images/bg.png',
  ];
  List names = [
    'Loletha Elayne Falana',
    'Robert	Patricia',
    'Gerald Joey',
    'Rick Victor',
    'Clarence Sandy',
  ];

  int updatedlike;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => Provider.of<AuthProvider>(context, listen: false).getourstories());

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    color: lightBlue,
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: white,
                  )),
            ],
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState.openDrawer();
                },
                child: Icon(Icons.menu)),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text('HOME'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Consumer<AuthProvider>(
                  builder: (context, provider, child) => FutureBuilder(
                    future: provider.getAllContinueStories(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      List<LocalStoriesResponse> response = snapshot.data as List<LocalStoriesResponse>;

                      return Visibility(
                        visible: response.length > 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Continue Reading',
                                        style: GoogleFonts.montserrat(
                                            // color: black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                        child: Container(
                                          height: 2,
                                          width: 150,
                                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Prefs.setReadingStories("");
                                      setState(() {});
                                    },
                                    child: Text(
                                      'CLEAR ALL',
                                      style: GoogleFonts.montserrat(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 180,
                              padding: const EdgeInsets.only(left: 16.0),
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: response.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 150,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      var mem = await Prefs.membership;

                                                      if (mem == '1' || mem == '2' || mem == '3' || mem == '4') {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    DetailScreen(response[index], false, response[index].audio, false)));
                                                      } else {
                                                        print("unsubscribed");
                                                        showAlert(context);
                                                      }
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: double.infinity,
                                                          width: double.infinity,
                                                          foregroundDecoration:
                                                              BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black12),
                                                          child: CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: response[index].featuredMediaSrcUrl,
                                                            progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                              child: SizedBox(
                                                                height: 10,
                                                                width: 10,
                                                                child: CircularProgressIndicator(value: downloadProgress.progress),
                                                              ),
                                                            ),
                                                            errorWidget: (context, url, error) => Icon(
                                                              Icons.photo_library,
                                                              size: 50,
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.bottomCenter,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              response[index].postTitle,
                                                              maxLines: 2,
                                                              style: GoogleFonts.montserrat(
                                                                color: white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.symmetric(vertical: 5),
                                                        width: 300,
                                                        height: 10,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          child: LinearProgressIndicator(
                                                            value: getPercentageValue(response[index]) as double,
                                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                              Color(0xff0891d9),
                                                            ),
                                                            backgroundColor: Colors.lightBlue.shade50,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Text(
                                                      "${getCompletionPercentage(response[index])} %",
                                                      style: GoogleFonts.montserrat(color: Colors.grey),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: GestureDetector(
                                            onTap: () async {
                                              provider.deleteContinueStory(response[index].id);
                                              await Prefs.setReadingStories(LocalStoriesResponse.encode([...provider.allContinueStories]));
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(20)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(Icons.delete, color: Colors.red),
                                                )),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Our Stories...',
                            style: GoogleFonts.montserrat(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 25),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 2,
                            width: 100,
                            decoration: BoxDecoration(color: Color(0xff0891d9), borderRadius: BorderRadius.circular(10)),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SeeMore()));
                        },
                        child: Text(
                          'SEE ALL',
                          style: GoogleFonts.montserrat(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Consumer<AuthProvider>(
                      builder: (context, provider, child) => provider.newstories.status == Status.LOADING
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : provider.newstories.data.length > 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: provider.newstories.data.length,
                                  itemBuilder: (context, index) {
                                    final user = provider.newstories.data[index];

                                    var htmldata = parse(user.postContent);
                                    var myList = htmldata.getElementsByTagName('p');
                                    var audioHtml = htmldata.getElementsByTagName('audio');

                                    var audio = audioHtml.length > 0 ? audioHtml[0].attributes['src'] : '';
                                    String parsedData;
                                    if (myList.isNotEmpty) {
                                      parsedData = myList[2].innerHtml;
                                    } else {
                                      parsedData = user.postContent;
                                    }
                                    if (index >= 9) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 4,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => SeeMore()));
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.lightBlue.shade100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(child: Text("See All")),
                                              )),
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                          horizontal: 4,
                                        ),
                                        child: GestureDetector(
                                          onTap: () async {
                                            var mem = await Prefs.membership;

                                            if (mem == '1' || mem == '2' || mem == '3' || mem == '4') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (contect) => DetailScreen(user, true, audio, false),
                                                ),
                                              );
                                            } else {
                                              print("unsubscribed");
                                              showAlert(context);
                                            }
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
                                                      progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
                                                        height: 30,
                                                        width: 30,
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
                                                                  style: GoogleFonts.montserrat(
                                                                      color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  EasyLoading.show();
                                                                  AuthProvider().addfavourite(user.id, 1).then((res) {
                                                                    provider.updateStoriesFavStatus(
                                                                      index,
                                                                    );

                                                                    CommonWidgets.buildSnackbar(
                                                                        context,
                                                                        user.isFavourite == "1"
                                                                            ? 'Added in Favourite stories'
                                                                            : 'Removed Favourite stories');
                                                                    EasyLoading.dismiss();
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
                                                          )),
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
                                                                      style: GoogleFonts.montserrat(
                                                                          color: lightBlue, fontWeight: FontWeight.w300, fontSize: 12),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top: 4.0),
                                                                    child: Text(
                                                                      user.likes,
                                                                      style: GoogleFonts.montserrat(
                                                                          color: Color(0xff999999), fontWeight: FontWeight.w600, fontSize: 13),
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
                                                                      style: GoogleFonts.montserrat(
                                                                          color: Color(0xff999999), fontWeight: FontWeight.w600, fontSize: 13),
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
                                    }
                                  })
                              : CircularProgressIndicator()
                      // }),
                      ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  getCompletionPercentage(LocalStoriesResponse response) {
    var finalPercentage;
    var percentage = (response.continueReading / response.totalReading) * 100;
    if (!percentage.isNaN) {
      finalPercentage = percentage.toStringAsFixed(0);
    } else {
      finalPercentage = "0";
    }
    return finalPercentage;
  }

  getPercentageValue(LocalStoriesResponse response) {
    double finalPercentage = 0;
    double percentage = response.continueReading / response.totalReading;
    if (!percentage.isNaN) {
      finalPercentage = percentage;
    }
    return finalPercentage;
  }
}
