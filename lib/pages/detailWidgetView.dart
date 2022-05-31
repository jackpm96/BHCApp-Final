import 'package:black_history_calender/components/detailviewWidget.dart';
import 'package:black_history_calender/screens/auth/model/newstories_response.dart';
import 'package:black_history_calender/screens/auth/model/search_response.dart';
import 'package:black_history_calender/services/page_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

class SearchResultView extends StatefulWidget {
  SearchResultView({this.dataList});

  final SearchResponse dataList;

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  List<LocalStoriesResponse> locallySavedStories;
  ScrollController _controller = ScrollController();

  LocalStoriesResponse _localStoriesResponse;
  PageManager _pageManager;

  @override
  void dispose() {
    _pageManager.pause();
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.navigate_before)
            // Icon(
            //   Icons.arrow_back_ios,
            //   size: 25,
            // ),
            ),
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: DetailWidget(list: dataList),
        ),
      ),
    );
  }
}
