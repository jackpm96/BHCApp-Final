// To parse this JSON data, do
//
//     final PostLikeData = PostLikeDataFromJson(jsonString);

import 'dart:convert';

PostLikeData PostLikeDataFromJson(String str) => PostLikeData.fromJson(json.decode(str));

String PostLikeDataToJson(PostLikeData data) => json.encode(data.toJson());

class PostLikeData {
  PostLikeData({
    this.status,
    this.response,
    this.code,
    this.data,
  });

  String status;
  String response;
  int code;
  String data;

  factory PostLikeData.fromJson(Map<String, dynamic> json) => PostLikeData(
    status: json["status"],
    response: json["response"],
    code: json["code"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response,
    "code": code,
    "data": data,
  };
}
