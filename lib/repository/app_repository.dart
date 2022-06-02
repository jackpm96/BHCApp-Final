import 'dart:convert';

import 'package:black_history_calender/screens/auth/model/fav_response.dart';
import 'package:black_history_calender/screens/auth/model/search_response.dart';
import 'package:http/http.dart';

class AppRepository {
  var client = Client();

  Future<SearchResponse> searchByKeyword(
      String token, String keyword, String perpage, String page, String userId, onResponse(SearchResponse list), onError(error)) async {
    var queryParameters = {
      'secret_key': token,
      'keyword': keyword,
      'perpage': perpage,
      'page': page,
      'user_id': userId,
    };
    String a = "myblackhistorycalendar.com";
    var url = Uri.https(a, "/wp-json/wcra/v1/search_by_keyword/", queryParameters);
    print("url => " + url.toString());
    final response = await client.get(url, headers: {'Content-type': 'application/json'});
    if (response.statusCode == 200) {
      try {
        var data = SearchResponse.fromJson(json.decode(response.body));
        onResponse(data);
        return data;
      } catch (error) {
        print("Catched");
        print(error);
        onError(error);
      }
    } else {
      throw Exception('Failed to load album');
    }
    return SearchResponse();
  }

  Future<FavResponse> getFavoritesPost(String token, String userId, onResponse(FavResponse list), onError(error)) async {
    print("Favorite API Called and error is ==");

    var queryParameters = {'secret_key': token, 'user_id': userId};
    String a = "myblackhistorycalendar.com";
    var url = Uri.https(a, "/wp-json/wcra/v1/favourite_post_get/", queryParameters);
    print("url => " + url.toString());
    final response = await client.get(url, headers: {'Content-type': 'application/json'});
    if (response.statusCode == 200) {
      try {
        var data = FavResponse.fromJson(json.decode(response.body) as Map<String, dynamic>);
        onResponse(data);
        print("Arrived Fav");
        return data;
      } catch (error) {
        print("Catched fav error");
        print(error);
        onError(error);
      }
    } else {
      throw Exception('Failed to load album');
    }
    return FavResponse();
  }
}
