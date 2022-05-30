// To parse this JSON data, do
//
//     final favResponse = favResponseFromJson(jsonString);

import 'dart:convert';

FavResponse favResponseFromJson(String str) =>
    FavResponse.fromJson(json.decode(str));

String favResponseToJson(FavResponse data) => json.encode(data.toJson());

class FavResponse {
  FavResponse({
    this.status,
    this.response,
    this.code,
    this.data,
  });

  String status;
  String response;
  int code;
  Data data;

  factory FavResponse.fromJson(Map<String, dynamic> json) => FavResponse(
        status: json["status"],
        response: json["response"],
        code: json["code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response,
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.data,
    this.headers,
    this.status,
  });

  List<Datum> data;
  List<dynamic> headers;
  int status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        headers: List<dynamic>.from(json["headers"].map((x) => x)),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "headers": List<dynamic>.from(headers.map((x) => x)),
        "status": status,
      };
}

class Datum {
  Datum({
    this.id,
    this.postTitle,
    this.postAuthor,
    this.postExcerpt,
    this.postContent,
    this.postDate,
    this.postStatus,
    this.commentCount,
    this.featuredMediaSrcUrl,
    this.likes,
    this.isFavourite,
  });

  String id;
  String postTitle;
  String postAuthor;
  String postExcerpt;
  String postContent;
  DateTime postDate;
  String postStatus;
  String commentCount;
  String featuredMediaSrcUrl;
  String likes;
  String isFavourite;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["ID"],
        postTitle: json["post_title"],
        postAuthor: json["post_author"],
        postExcerpt: json["post_excerpt"],
        postContent: json["post_content"],
        postDate: DateTime.parse(json["post_date"]),
        postStatus: json["post_status"],
        commentCount: json["comment_count"],
        featuredMediaSrcUrl: json["featured_media_src_url"],
        likes: json["likes"],
        isFavourite: json["is_favourite"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "post_title": postTitle,
        "post_author": postAuthor,
        "post_excerpt": postExcerpt,
        "post_content": postContent,
        "post_date": postDate.toIso8601String(),
        "post_status": postStatus,
        "comment_count": commentCount,
        "featured_media_src_url": featuredMediaSrcUrl,
        "likes": likes,
        "is_favourite": isFavourite,
      };
}
