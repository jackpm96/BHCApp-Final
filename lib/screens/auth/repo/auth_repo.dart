import 'dart:async';
import 'dart:io';

import 'package:black_history_calender/helper/prefs.dart';
import 'package:black_history_calender/network_module/api_base.dart';
import 'package:black_history_calender/network_module/api_path.dart';
import 'package:black_history_calender/network_module/http_client.dart';
import 'package:black_history_calender/screens/auth/model/account_details_response.dart';
import 'package:black_history_calender/screens/auth/model/addfavourite_response.dart';
import 'package:black_history_calender/screens/auth/model/addsetting_response.dart';
import 'package:black_history_calender/screens/auth/model/dob_response.dart';
import 'package:black_history_calender/screens/auth/model/fav_response.dart';
import 'package:black_history_calender/screens/auth/model/forgot_response.dart';
import 'package:black_history_calender/screens/auth/model/getcomment_response.dart';
import 'package:black_history_calender/screens/auth/model/getlike_response.dart';
import 'package:black_history_calender/screens/auth/model/img_response.dart';
import 'package:black_history_calender/screens/auth/model/login_response.dart';
import 'package:black_history_calender/screens/auth/model/newstories_response.dart';
import 'package:black_history_calender/screens/auth/model/postcomment_response.dart';
import 'package:black_history_calender/screens/auth/model/signup_response.dart';
import 'package:black_history_calender/screens/auth/model/stories_response.dart';
import 'package:black_history_calender/screens/auth/model/token_validate_response.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:http/http.dart' as http;

int currentpage = 1;
int totalPages;

class AuthRepo {
  Future<UpdateDobResponse> updateDobApi(String userID, String dob) async {
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";
    var params = {
      "secret_key": key,
      "user_id": userID,
      "dob": dob,
    };

    final response = await HttpClient.instance.fetchData(
      APIPathHelper.getValue(APIPath.updateDob),
      params: params,
    );

    return UpdateDobResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<UpdateImgResponse> updateImgApi(String userID, String img) async {
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";
    var params = {
      "secret_key": key,
      "user_id": userID,
      "img": img,
    };

    final response = await HttpClient.instance.fetchData(
      APIPathHelper.getValue(APIPath.updateImg),
      params: params,
    );

    return UpdateImgResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<TokenValidateResponse> checkTokenValidate(var token) async {
    Map<String, String> body = Map<String, String>();

    var header = {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded', 'Authorization': 'Bearer $token'};

    final response = await HttpClient.instance.postData(
      APIPathHelper.getValue(APIPath.validateToken),
      body,
      header,
    );

    return TokenValidateResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<http.Response> makeMonthlySubscription(userID, token, String level) async {
    Map<String, String> body = Map<String, String>();
    Map<String, String> params = {"user_id": userID.toString(), "level_id": level};
    Map<String, String> header = {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded', 'Authorization': 'Bearer $token'};
    var uri =
        APIBase.baseURL + APIPathHelper.getValue(APIPath.monthlySubscription) + ((params != null) ? HttpClient.instance.queryParameters(params) : "");
    final response = await http.post(Uri.parse(uri), body: body, headers: header);

    return response;
  }

  Future<http.Response> makeYearlySubscription(userID, token) async {
    Map<String, String> body = Map<String, String>();
    Map<String, String> params = {"user_id": userID.toString(), "level_id": "1"};

    var uri =
        APIBase.baseURL + APIPathHelper.getValue(APIPath.monthlySubscription) + ((params != null) ? HttpClient.instance.queryParameters(params) : "");
    final response = await http.get(Uri.parse(uri));

    return response;
  }

  // Future<dynamic> makeYearlySubscription(userID, token) async {
  //   Map<String, String> body = Map<String, String>();
  //   var params = {"user_id": userID, "level_id": "1"};
  //   final response = await HttpClient.instance.fetchData(
  //       APIPathHelper.getValue(APIPath.monthlySubscription),
  //       params: params);
  //   return response;
  // }

  Future<List<StoriesResponse>> getStores() async {
    Map<String, String> body = Map<String, String>();
    var params = null;

    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    List response =
        await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.Stories), params: params as Map<String, String>) as List<dynamic>;

    return response.map((e) => StoriesResponse.fromJson(e as Map<String, String>)).toList();
  }

  Future<AccountDetails> getDetails() async {
    Map<String, String> body = Map<String, String>();
    Map<String, String> params = null;

    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    var response = await HttpClient.instance.fetchData(
      APIPathHelper.getValue(APIPath.account) + "/" + "1",
      params: params,
    );
    return AccountDetails.fromJson(response as Map<String, dynamic>);
  }

  Future<LikesData> getLikes(var postid) async {
    Map<String, String> body = Map<String, String>();
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";

    var params = {"secret_key": key, "post_id": postid.toString()};
    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    var response = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.likesdata), params: params);
    return LikesData.fromJson(response as Map<String, dynamic>);
  }

  Future<LikesData> postlike(var postid, var value) async {
    Map<String, String> body = Map<String, String>();
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";
    final ipv4 = await Ipify.ipv4();
    var userid = await Prefs.id;
    var params = {
      "secret_key": key,
      "post_id": postid.toString(),
      "value": value.toString(),
      "ip": ipv4.toString(),
      "user_id": userid.toString(),
    };

    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    final response = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.postlike), body, header, params: params);
    return LikesData.fromJson(response as Map<String, dynamic>);
  }

  Future<ForgotResponse> resetPassword(String email, String password, String passcode) async {
    Map<String, String> body = Map<String, String>();
    var params = {
      "email": email,
      "password": password,
      "code": passcode,
    };

    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    final response = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.resetPassword), body, header, params: params);
    return ForgotResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<ForgotResponse> forgotPassword(String email) async {
    Map<String, String> body = Map<String, String>();
    var params = {
      "email": email,
    };

    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    final response = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.forgot), body, header, params: params);
    return ForgotResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<LoginResponse> loginUser(String userName, String password, String token) async {
    Map<String, String> body = Map<String, String>();
    var params = {
      "username": userName,
      "password": password,
      "noti_token": token,
    };
    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    final response = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.signin), body, header, params: params);
    return LoginResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<SignupResponse> signupUser(String userName, String email, String password, String name, String firstName, String lastName) async {
    final Map<String, String> body = <String, String>{};
    final params = {
      "username": userName,
      "email": email,
      "password": password,
      "name": name,
      "first_name": firstName,
      "last_name": lastName,
    };

    // var header = {
    //   // HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    //   // 'Authorization': 'Bearer $token'
    // };

    final response = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.signup), body, null, params: params);
    return SignupResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<StoriesResponse> addStory(String token, String title, String content, String author, dynamic image) async {
    Map<String, String> body = Map<String, String>();
    var params = {
      "title": title,
      "content": content,
      "author": author,
      "excerpt": content,
      "featured_media": "$image",
      "categories": "1",
      "status": "publish",
    };

    var header = {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded', 'Authorization': 'Bearer $token'};
    final response = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.addstories), body, header, params: params);
    return StoriesResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<List<StoryData>> calendarsearch(var from, var until, currentpage) async {
    Map<String, String> body = Map<String, String>();
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";
    var userid = await Prefs.id;
    var params = {
      'secret_key': key,
      'before': until.toString() + 'T00:00:00',
      'after': from.toString() + 'T00:00:00',
      'user_id': userid.toString(),
      'per_page': '10',
      'page': currentpage.toString()
    };

    var response = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.calendar), params: params);

    return TopLevel.fromJson(response as Map<String, dynamic>).data;
  }

  Future<List<GetCommentResponse>> getcomments(var postid) async {
    Map<String, String> body = Map<String, String>();

    var params = {"post": postid.toString()};
    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    final List response = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.comments), params: params) as List<dynamic>;
    return response.map((e) => GetCommentResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PostCommentResponse> postcomments(var postid, var comment) async {
    Map<String, String> body = Map<String, String>();
    var token = await Prefs.token;
    var userid = await Prefs.id;
    var params = {"post": postid.toString(), "author": userid.toString(), 'content': comment.toString()};

    var header = {HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded', 'Authorization': 'Bearer $token'};
    final response = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.comments), body, header, params: params);

    return PostCommentResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<AddSettingResponse> SettingInfo(var noti_status, var email_status) async {
    Map<String, String> body = Map<String, String>();
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";
    final ipv4 = await Ipify.ipv4();
    var userid = await Prefs.id;
    var params = {
      "secret_key": key,
      "notification_active": noti_status.toString(),
      "email_active": email_status.toString(),
      "ip": ipv4.toString(),
      "user_id": userid.toString(),
    };

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    final response = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.addsetting), body, headers, params: params);
    return AddSettingResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<List<StoryData>> getourstories() async {
    Map<String, String> body = Map<String, String>();
    var userid = await Prefs.id;
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";
    var params = {
      "secret_key": key,
      if (userid != null) "user_id": userid.toString(),
    };
    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    var response = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.newstories), params: params);

    return TopLevel.fromJson(response as Map<String, dynamic>).data;
  }

  Future<FavResponse> getFavStories() async {
    var userid = await Prefs.id;
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";
    var params = {
      "secret_key": key,
      if (userid != null) "user_id": userid.toString(),
    };
    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    var response = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.favStories), params: params);

    return FavResponse.fromJson(response as Map<String, dynamic>);
  }

  Future<List<StoryData>> loadmoredata(currentpage) async {
    Map<String, String> body = Map<String, String>();
    var userid = await Prefs.id;
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";
    var params = {
      "secret_key": key,
      "user_id": userid.toString(),
      'page': currentpage.toString(),
      'perpage': '10',
    };
    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    var response = await HttpClient.instance.fetchData(APIPathHelper.getValue(APIPath.newstories), params: params);

    return TopLevel.fromJson(response as Map<String, dynamic>).data;
  }

  Future<AddFavouriteResponse> addfavourite(var postid, var value) async {
    Map<String, String> body = Map<String, String>();
    String key = "Pf1PZMTEum3zLBkN2ITu4KdZyHM3WKR0";
    final ipv4 = await Ipify.ipv4();
    var userid = await Prefs.id;
    var params = {
      "secret_key": key,
      "post_id": postid.toString(),
      "value": value.toString(),
      "ip": ipv4.toString(),
      "user_id": userid.toString(),
    };

    var header = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };
    final response = await HttpClient.instance.postData(APIPathHelper.getValue(APIPath.addfavourite), body, header, params: params);
    return AddFavouriteResponse.fromJson(response as Map<String, dynamic>);
  }
}
