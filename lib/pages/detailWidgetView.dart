import 'package:black_history_calender/components/detailviewWidget.dart';
import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/pages/my_profile.dart';
import 'package:black_history_calender/repository/app_repository.dart';
import 'package:black_history_calender/screens/auth/model/newstories_response.dart';
import 'package:black_history_calender/screens/auth/model/search_response.dart';
import 'package:black_history_calender/screens/home/home_screen.dart';
import 'package:black_history_calender/services/page_manager.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';

import '../globals.dart';
import 'detail_screen.dart';

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
