import 'package:black_history_calender/components/mydialog.dart';
import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/repository/app_repository.dart';
import 'package:black_history_calender/screens/auth/model/fav_response.dart';
import 'package:black_history_calender/screens/auth/model/newstories_response.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';

import 'detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final bool showAppBar;

  const FavoritesScreen({Key key, this.showAppBar}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  var appRepository = AppRepository();

  TextEditingController editingController = TextEditingController();

  String id = "";

  String token = "";

  bool isGetRequest = true;

  List<Datum> favDataList;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    token = await Prefs.token;

    await Prefs.id.then((value) {
      setState(() {
        id = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: ()=>showSearch(context: context, delegate: Search()),
      //   child: Icon(Icons.search),
      // ),
        appBar: AppBar(
          backgroundColor: lightBlue,
          title: InkWell(onTap: (){},
              child: Text("Favorites")),
          leading: IconButton(
              onPressed: () {
                if (widget.showAppBar) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.navigate_before)),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 8, right: 8, bottom: 8, top: 20),
              //   child: TextField(
              //     onChanged: (value) {},
              //     controller: editingController,
              //     decoration: InputDecoration(
              //         labelText: "Search",
              //         hintText: "Search",
              //         prefixIcon: Icon(Icons.search),
              //         suffixIcon: InkWell(
              //           onTap: (){
              //             setState(() {
              //               isGetRequest=true;
              //             });
              //           },
              //             child: Icon(
              //           Icons.check,
              //           color:
              //               (isGetRequest) ? Colors.orange : lightBlue,
              //         )),
              //         border: OutlineInputBorder(
              //             borderRadius:
              //                 BorderRadius.all(Radius.circular(25.0)))),
              //   ),
              // ),
              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.3,
              //   child: RawMaterialButton(
              //     onPressed: () {
              //       setState(() {
              //         isGetRequest = true;
              //       });
              //     },
              //     fillColor: lightBlue,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(15),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(
              //             Icons.search_rounded,
              //             color: white,
              //             size: 20,
              //           ),
              //           Text(
              //             'Search',
              //             style: TextStyle(
              //               color: white,
              //               fontSize: 18,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              (isGetRequest)
                  ? FutureBuilder<FavResponse>(
                future: appRepository.getFavoritesPost(
                    "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0", id,
                        (FavResponse list) {
                      print("Done Done Done favv favv");
                      isGetRequest = false;
                      print("Done Done Done fav");
                    }, (error) {
                  print("failed");
                  isGetRequest = false;
                }),
                builder: (BuildContext context,
                    AsyncSnapshot<FavResponse> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        height: 200,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    default:
                      if (snapshot.hasData &&
                          snapshot.data.status == "OK" &&
                          snapshot.data.data != null && snapshot.data.data.data.length>0) {
                        isGetRequest = false;
                        favDataList = snapshot.data.data.data;

                        print("ifffff");
                        return mainListView(favDataList);
                      }
                      else if (snapshot.data.status == "OK" &&
                          snapshot.data.data != null && snapshot.data.data.data.length==0) {
                        isGetRequest = false;
                        print("else iff");
                        return  Container(
                          height: MediaQuery.of(context).size.height*0.7,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.grey,
                                    size: 60,
                                  ),
                                  Text(
                                    "No Favorites Yet.",
                                    style:
                                    GoogleFonts.montserrat(
                                        color: Color(0xff999999),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  )
                                ],
                              )),
                        );
                      }
                      else { print("else");
                      return  Container(
                        height: MediaQuery.of(context).size.height*0.7,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  color: Colors.grey,
                                  size: 60,
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      isGetRequest=true;
                                    });
                                  },
                                  child: Text(
                                    "Try Again",
                                    style:
                                    GoogleFonts.montserrat(
                                        color: Color(0xff999999),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                )
                              ],
                            )),
                      );
                      }
                  }
                },
              )
                  : mainListView(favDataList)
            ],
          ),
        ));
  }

  Widget mainListView(List<Datum> list) {
    return Column(
      children: [
        ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final user = list;
              // provider.favStories
              //     .data.data.data[index];

              var htmldata = parse(user[index].postContent);
              var myList = htmldata.getElementsByTagName('p');
              var parsedData;
              if (myList.isNotEmpty) {
                parsedData = myList[2].innerHtml;
              } else {
                parsedData = user[index].postContent;
              }
              var audioHtml = htmldata.getElementsByTagName('audio');

              var audio =
              audioHtml.length > 0 ? audioHtml[0].attributes['src'] : '';

              AuthProvider provider = AuthProvider();

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4,
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (await FlutterInappPurchase.instance.checkSubscribed(
                      sku: "bhc_monthly_subb",
                    )) {
                      print("subscribed");
                      CommonWidgets.buildSnackbar(context, "subscribed");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(user as StoryData, false, audio,false)))
                          .then((value) => setState(() {}));
                    }
                   else if (await FlutterInappPurchase.instance.checkSubscribed(
                      sku: "bhc_yearly_subb",
                    )) {
                      print("subscribed");
                      CommonWidgets.buildSnackbar(context, "subscribed");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(user as StoryData, false, audio,false)))
                          .then((value) => setState(() {}));
                    }
                    else {
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
                              imageUrl: user[index].featuredMediaSrcUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: 80.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Container(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
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
                                          user[index].postTitle,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: ()  {

                                          EasyLoading.show();
                                          AuthProvider()
                                              .addfavourite(user[index].id,1)
                                              .then((res) {
                                            provider.updateStoriesFavStatus(
                                              index,
                                            );

                                            setState(() {
                                              user[index].isFavourite =
                                              user[index]
                                                  .isFavourite
                                                  .contains("1")
                                                  ? "0"
                                                  : "1";
                                            });


                                            EasyLoading.dismiss();

                                          }).whenComplete((){
                                            setState(() {
                                              isGetRequest=true;
                                            });
                                          });


                                          // setState(() {
                                          //   isGetRequest=true;
                                          // });

                                        },
                                        child: Icon(
                                          user[index].isFavourite == "1"
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          color: user[index].isFavourite == "1"
                                              ? Colors.red
                                              : Colors.grey,
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
                                              "${user[index].postDate.year}-${user[index].postDate.month}-${user[index].postDate.day}",
                                              style: GoogleFonts.montserrat(
                                                  color: lightBlue,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12),
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
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                user[index].likes,
                                                style: GoogleFonts.montserrat(
                                                    color: Color(0xff999999),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
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
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(
                                                user[index].commentCount,
                                                style: GoogleFonts.montserrat(
                                                    color: Color(0xff999999),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(top: 5),
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
      ],
    );
  }
}