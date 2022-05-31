import 'dart:convert';

import 'package:black_history_calender/components/detailviewWidget.dart';
import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/repository/app_repository.dart';
import 'package:black_history_calender/screens/auth/model/search_response.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../globals.dart';
import 'detailWidgetView.dart';

class BookMarkPage extends StatefulWidget {
  final bool showAppBar;

  const BookMarkPage({Key key, this.showAppBar}) : super(key: key);

  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  var appRepository = AppRepository();

  TextEditingController editingController = TextEditingController();

  String id = "";

  String token = "";

// Initial Selected Value
  String dropdownvalue = '';
  String dropdownvaluec = 'No Category Found';

  // List of items in our dropdown menu
  List<String> items = [
    // 'abolitionist',
    // 'Activist',
    // 'Actor',
    // 'agriculture',
    // 'armed forces',
    // 'artist',
    // 'athlete',
    // 'basketball',
    // 'blackpanthers',
  ];
  var itemsc = [
    'abolitionist',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  bool isGettingRequest = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<List> getTags() async {
    var url = 'https://myblackhistorycalendar.com/wp-json/wp/v2/tags';
    final response = await http.get(
      Uri.parse(url),
    );
    var result = jsonDecode(response.body);
    return result;
  }

  initData() async {
    // setState(() {
    //   isSearchRequest = true;
    // });

    token = await Prefs.token;
    await getTags().then((value) {
      value.forEach((element) {
        setState(() {
          items.add(element['name'].toString());
        });
      });
    });
    setState(() {
      dropdownvalue = items[0];
      isGettingRequest = false;
    });
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
          title:
              // InkWell(
              //     onTap: () {
              //       showSearch(context: context, delegate: Search()).then((value) {
              //         setState(() {});
              //       });
              //     },
              //     child:
              Text("Search")
          // )
          ,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                if (widget.showAppBar) {
                  pageController.jumpTo(0);
                } else {
                  /*   Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) => const MyProfile(
                     // showAppBar: false,

                    ),),(route) => true);
*/
                  // onceLoaded:false;
                  pageController.jumpTo(0);
                }
              },
              icon: Icon(Icons.navigate_before)),
        ),
        body: Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: isGettingRequest
                ? Container(
                    height: 200,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      // mainListView(dataList)

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
                      //               isSearchRequest=true;
                      //             });
                      //           },
                      //             child: Icon(
                      //           Icons.check,
                      //           color:
                      //               (isSearchRequest) ? Colors.orange : lightBlue,
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
                      //         isSearchRequest = true;
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
                      (isSearchRequest)
                          ? FutureBuilder<SearchResponse>(
                              future: appRepository.searchByKeyword("Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0", searchQuery, "100", "1", id,
                                  (SearchResponse list) {
                                print("Done Done Done");
                                isSearchRequest = false;
                                onceLoaded = true;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchResultView(
                                              dataList: dataList,
                                            ))).then((value) => setState(() {
                                      onceLoaded = false;
                                    }));
                                print("Done Done Done");
                              }, (error) {
                                print("failed");
                                isSearchRequest = false;
                              }),
                              builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
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
                                        snapshot.data.data != null &&
                                        snapshot.data.data.length > 0) {
                                      isSearchRequest = false;
                                      dataList = snapshot.data;

                                      return DetailWidget(list: dataList);
                                    } else if (snapshot.data.status == "OK" && snapshot.data.data == null) {
                                      isSearchRequest = false;

                                      return Container(
                                        height: 200,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Nothing Close Found",
                                                style: TextStyle(color: Colors.red, fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 200,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isSearchRequest = true;
                                                  });
                                                },
                                                child: Text(
                                                  "Try Again",
                                                  style: TextStyle(color: Colors.red, fontSize: 20),
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isSearchRequest = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.refresh,
                                                    color: Colors.red,
                                                    size: 25,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                }
                              },
                            )
                          :
                          // (onceLoaded)
                          //         ? DetailWidget(list: dataList)
                          //         :
                          Container(
                              // height: MediaQuery.of(context).size.height*0.7,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showSearch(context: context, delegate: Search()).then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                      // width: double.infinity,
                                      alignment: Alignment.center,

                                      height: 100,
                                      decoration: BoxDecoration(
                                          border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.05),
                                          width: 1,
                                          style: BorderStyle.solid,
                                        ),
                                      )),
                                      //  width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.search_rounded,
                                                color: Colors.grey,
                                                size: 40,
                                              ),
                                              Text(
                                                "Search By Name",
                                                style: GoogleFonts.montserrat(color: Color(0xff999999), fontWeight: FontWeight.w500, fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Search By Tags",
                                        style: GoogleFonts.montserrat(color: Colors.lightBlue, fontWeight: FontWeight.w500, fontSize: 16),
                                      ),
                                      DropdownButton(
                                        // Initial Value
                                        value: dropdownvalue,

                                        // Down Arrow Icon
                                        icon: const Icon(Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: items.map((String item) {
                                          return DropdownMenuItem(
                                            value: item,
                                            child: Text(item.toUpperCase()),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropdownvalue = newValue;
                                            // Navigator.pop(context);
                                            searchQuery = newValue;
                                            print(searchQuery);
                                            isSearchRequest = true;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              )),
                            )
                    ],
                  ),
          ),
        ));
  }

// getData(){
//
//   appRepository.searchByKeyword(
//                   "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0",
//                   searchQuery,
//                   "100",
//                   "1",
//                   id, (SearchResponse list) {
//                     dataList=list;
//
//                 print("Done Done Done");
//                 isSearchRequest = false;
//                 onceLoaded = true;
//                 print("Done Done Done");
//               }, (error) {
//                 print("failed");
//                 isSearchRequest = false;
//               })
// }

// Widget mainListView(SearchResponse list) {
//   return Column(
//     children: [
//       ListView.builder(
//           physics: BouncingScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: list.data.length,
//           itemBuilder: (context, index) {
//             final user = list.data;
//             // provider.favStories
//             //     .data.data.data[index];
//
//             var htmldata = parse(user[index].postContent);
//             var myList = htmldata.getElementsByTagName('p');
//             var parsedData;
//             if (myList.isNotEmpty) {
//               parsedData = myList[2].innerHtml;
//             } else {
//               parsedData = user[index].postContent;
//             }
//             var audioHtml = htmldata.getElementsByTagName('audio');
//
//             var audio =
//                 audioHtml.length > 0 ? audioHtml[0].attributes['src'] : '';
//
//             return Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8.0,
//                 horizontal: 4,
//               ),
//               child: GestureDetector(
//                 onTap: () async {
//                   if (await FlutterInappPurchase.instance.checkSubscribed(
//                     sku: "bhc_monthly_sub",
//                   )) {
//                     print("subscribed");
//                     CommonWidgets.buildSnackbar(context, "subscribed");
//                     Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     DetailScreen(user[index], false, audio)))
//                         .then((value) => setState(() {}));
//                   } else {
//                     print("unsubscribed");
//                     CommonWidgets.buildSnackbar(context, "unsubscribed");
//                   }
//                 },
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Container(
//                     height: 120,
//                     width: MediaQuery.of(context).size.width,
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 120,
//                           height: MediaQuery.of(context).size.height,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(
//                               10,
//                             ),
//                           ),
//                           child: CachedNetworkImage(
//                             color: Colors.black45,
//                             fit: BoxFit.cover,
//                             imageUrl: user[index].featuredMediaSrcUrl,
//                             imageBuilder: (context, imageProvider) =>
//                                 Container(
//                               width: 80.0,
//                               height: 80.0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.rectangle,
//                                 borderRadius: BorderRadius.circular(10),
//                                 image: DecorationImage(
//                                     image: imageProvider, fit: BoxFit.cover),
//                               ),
//                             ),
//                             progressIndicatorBuilder:
//                                 (context, url, downloadProgress) => Container(
//                               height: 10,
//                               width: 10,
//                               child: CircularProgressIndicator(
//                                   value: downloadProgress.progress),
//                             ),
//                             errorWidget: (context, url, error) => Icon(
//                               Icons.photo_library,
//                               size: 50,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(
//                               8.0,
//                             ),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         user[index].postTitle,
//                                         style: GoogleFonts.montserrat(
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 14),
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         EasyLoading.show();
//                                         // AuthProvider()
//                                         //     .addfavourite(user[index].id, 1)
//                                         //     .then((res) {
//                                         //   provider.updateFavStatus(
//                                         //     index,
//                                         //   );
//                                         //
//                                         //   CommonWidgets.buildSnackbar(context,
//                                         //       res.data.data == 1 ? 'Added in Favourite stories' : 'Removed Favourite stories');
//                                         //   EasyLoading.dismiss();
//                                         // });
//                                       },
//                                       child: Icon(
//                                         user[index].isFavourite == "1"
//                                             ? Icons.favorite
//                                             : Icons.favorite_border_outlined,
//                                         color: user[index].isFavourite == "1"
//                                             ? Colors.red
//                                             : Colors.grey,
//                                         size: 20,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 6,
//                                 ),
//                                 Expanded(
//                                     child: Html(
//                                   data: parsedData,
//                                   onLinkTap: (url, _, __, ___) {
//                                     launch(url);
//                                   },
//                                   onImageTap: (src, _, __, ___) {
//                                     launch(src);
//                                   },
//                                 )
//
//                                     //     Text(
//                                     //   user.excerpt.rendered,
//                                     //   overflow: TextOverflow
//                                     //       .ellipsis,
//                                     //   maxLines: 3,
//                                     //   style: GoogleFonts
//                                     //       .montserrat(
//                                     //           fontSize: 10,
//                                     //           color: Color(
//                                     //               0xff818181)),
//                                     // )),
//                                     ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.access_time,
//                                             color: lightBlue,
//                                             size: 15,
//                                           ),
//                                           SizedBox(
//                                             width: 4,
//                                           ),
//                                           Text(
//                                             user[index].postDate,
//                                             style: GoogleFonts.montserrat(
//                                                 color: lightBlue,
//                                                 fontWeight: FontWeight.w300,
//                                                 fontSize: 12),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       // onTap: () {
//                                       //   setState(() {
//                                       //     updatedlike++;
//                                       //   });
//                                       //   AuthProvider()
//                                       //       .postlike(
//                                       //           user[index].id,
//                                       //           updatedlike)
//                                       //       .then((value) =>
//                                       //           setState(
//                                       //               () {}));
//                                       // },
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         mainAxisSize: MainAxisSize.max,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 4.0),
//                                             child: Text(
//                                               user[index].likes,
//                                               style: GoogleFonts.montserrat(
//                                                   color: Color(0xff999999),
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 13),
//                                             ),
//                                           ),
//                                           Image.asset(
//                                             "assets/images/like_thumb.png",
//                                             height: 15,
//                                             width: 15,
//                                             // fit: BoxFit.contain,
//                                           ),
//                                           SizedBox(
//                                             width: 6,
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 4.0),
//                                             child: Text(
//                                               user[index].commentCount,
//                                               style: GoogleFonts.montserrat(
//                                                   color: Color(0xff999999),
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 13),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 1,
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(top: 5),
//                                             child: Image.asset(
//                                               "assets/images/comment.png",
//                                               height: 17,
//                                               width: 17,
//                                               color: Colors.blue,
//                                               // fit: BoxFit.contain,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//     ],
//   );
// }
}

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(
            Icons.search,
            color: (isSearchRequest) ? Colors.orange : Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
            searchQuery = query;
            print(searchQuery);
            isSearchRequest = true;
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context, false));
  }

  @override
  // ignore: missing_return
  Widget buildResults(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // add your code here.
      if (query != null) {
        Navigator.pop(context);
        searchQuery = query;
        print(searchQuery);
        isSearchRequest = true;
      }
    });
    return Text(
      "Hamza",
      style: TextStyle(color: white.withOpacity(0)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text(
      "Hamza",
      style: TextStyle(color: white.withOpacity(0)),
    );
  }
}
