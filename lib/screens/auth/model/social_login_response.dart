// To parse this JSON data, do
//
//     final socialLoginResponse = socialLoginResponseFromJson(jsonString);

import 'dart:convert';

SocialLoginResponse socialLoginResponseFromJson(String str) =>
    SocialLoginResponse.fromJson(json.decode(str));

String socialLoginResponseToJson(SocialLoginResponse data) =>
    json.encode(data.toJson());

class SocialLoginResponse {
  SocialLoginResponse({
    this.status,
    this.code,
    this.data,
  });

  String status;
  int code;
  Data data;

  factory SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    print(json);
 return   SocialLoginResponse(
      status: json["status"],
      code: json["code"],
      data: Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "data": data.toJson(),
      };
}

class Data {
  Data(
      {this.token,
      this.userId,
      this.userEmail,
      this.userNicename,
      this.userDisplayName,
      this.message,
      this.membershipLevel,
      this.dob,
      this.imgurl});

  dynamic token;
  dynamic userId;
  dynamic userEmail;
  dynamic userNicename;
  dynamic userDisplayName;
  dynamic message;
  dynamic membershipLevel;
  dynamic dob;
  dynamic imgurl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        userId: json["user_id"],
        userEmail: json["user_email"],
        userNicename: json["user_nicename"],
        userDisplayName: json["user_display_name"],
        message: json["message"],
        membershipLevel: json["membership_level"],
        dob: json["user_dob"],
        imgurl: json["user_img"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user_id": userId,
        "user_email": userEmail,
        "user_nicename": userNicename,
        "user_display_name": userDisplayName,
        "message": message,
        "membership_level": membershipLevel,
        "user_dob": dob,
        "user_img" : imgurl
      };
}
