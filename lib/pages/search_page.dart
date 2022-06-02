import 'dart:convert';

import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/pages/resultView.dart';
import 'package:black_history_calender/repository/app_repository.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../globals.dart';

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
        appBar: AppBar(
          backgroundColor: lightBlue,
          title: Text("Search"),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                if (widget.showAppBar) {
                  pageController.jumpTo(0);
                } else {
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
                      Container(
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
                                  // setState(() {
                                  //
                                  // });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResultView(
                                                searchQuery: searchQuery,
                                              ))).then((value) => setState(() {
                                        onceLoaded = false;
                                      }));
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
                                      print("searchQuery $searchQuery");
                                      isSearchRequest = true;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ResultView(
                                                  searchQuery: searchQuery,
                                                ))).then((value) => setState(() {
                                          onceLoaded = false;
                                        }));
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
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ResultView(
            //               searchQuery: searchQuery,
            //             )));
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
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ResultView(
        //               searchQuery: searchQuery,
        //             )));
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
