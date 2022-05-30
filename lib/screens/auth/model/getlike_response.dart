// To parse this JSON data, do
//
//     final LikesData = LikesDataFromJson(jsonString);

import 'dart:convert';

LikesData LikesDataFromJson(String str) => LikesData.fromJson(json.decode(str));

String LikesDataToJson(LikesData data) => json.encode(data.toJson());

class LikesData {
  LikesData({
    this.status,
    this.response,
    this.code,
    this.data,
  });

  String status;
  String response;
  int code;
  String data;

  factory LikesData.fromJson(Map<String, dynamic> json) => LikesData(
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
