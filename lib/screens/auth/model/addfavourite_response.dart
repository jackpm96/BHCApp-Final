// To parse this JSON data, do
//
//     final AddFavouriteResponse = AddFavouriteResponseFromJson(jsonString);

import 'dart:convert';

AddFavouriteResponse AddFavouriteResponseFromJson(String str) => AddFavouriteResponse.fromJson(json.decode(str));

String AddFavouriteResponseToJson(AddFavouriteResponse data) => json.encode(data.toJson());

class AddFavouriteResponse {
  AddFavouriteResponse({
    this.status,
    this.response,
    this.code,
    this.data,
  });

  String status;
  String response;
  int code;
  Data data;

  factory AddFavouriteResponse.fromJson(Map<String, dynamic> json) => AddFavouriteResponse(
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

  int data;
  List<dynamic> headers;
  int status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"],
    headers: List<dynamic>.from(json["headers"].map((x) => x)),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "headers": List<dynamic>.from(headers.map((x) => x)),
    "status": status,
  };
}
