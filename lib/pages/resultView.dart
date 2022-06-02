import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/detailviewWidget.dart';
import '../globals.dart';
import '../repository/app_repository.dart';
import '../screens/auth/model/search_response.dart';

class ResultView extends StatefulWidget {
  ResultView({searchQuery});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  var appRepository = AppRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: GestureDetector(
            onTap: () {
              print("Navi");
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
        child: FutureBuilder<SearchResponse>(
          future: appRepository.searchByKeyword("Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0", searchQuery, "100", "1", id, (SearchResponse list) {
            print("Done Done Done");
            isSearchRequest = false;
            onceLoaded = true;
            print("Done Done Done");
          }, (error) {
            print("failed");

            isSearchRequest = false;
            return Text(
              "Something went wrong!",
              style: TextStyle(color: Colors.red, fontSize: 20),
            );
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
                if (snapshot.hasData && snapshot.data.status == "OK" && snapshot.data.data != null && snapshot.data.data.length > 0) {
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
        ),
      )),
    );
  }
}
