// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.token,
    this.userEmail,
    this.userNicename,
    this.userDisplayName,
    this.userId,
    this.userLogin,
    this.userFirstName,
    this.userLastName,
    this.userRoles,
    this.userRole,
    this.userRegistered,
    this.userUrl,
    this.userStatus,
    this.userAvatarUrl,
    this.userActivationKey,
    this.notiToken,
    this.membershipLevel,
    this.dob,
    this.imgurl,
  });

  String token;
  String userEmail;
  String userNicename;
  String userDisplayName;
  int userId;
  String userLogin;
  String userFirstName;
  String userLastName;
  List<String> userRoles;
  String userRole;
  DateTime userRegistered;
  String userUrl;
  String userStatus;
  String userAvatarUrl;
  String userActivationKey;
  String notiToken;
  String membershipLevel;
  String dob;
  String imgurl;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        userEmail: json["user_email"],
        userNicename: json["user_nicename"],
        userDisplayName: json["user_display_name"],
        userId: json["user_id"],
        userLogin: json["user_login"],
        userFirstName: json["user_first_name"],
        userLastName: json["user_last_name"],
        userRoles: List<String>.from(json["user_roles"].map((x) => x)),
        userRole: json["user_role"],
        userRegistered: DateTime.parse(json["user_registered"]),
        userUrl: json["user_url"],
        userStatus: json["user_status"],
        userAvatarUrl: json["user_avatar_url"],
        userActivationKey: json["user_activation_key"],
        notiToken: json["noti_token"],
        membershipLevel: json["membership_level"],
        dob: json["user_dob"],
        imgurl: json["user_img"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user_email": userEmail,
        "user_nicename": userNicename,
        "user_display_name": userDisplayName,
        "user_id": userId,
        "user_login": userLogin,
        "user_first_name": userFirstName,
        "user_last_name": userLastName,
        "user_roles": List<dynamic>.from(userRoles.map((x) => x)),
        "user_role": userRole,
        "user_registered": userRegistered.toIso8601String(),
        "user_url": userUrl,
        "user_status": userStatus,
        "user_avatar_url": userAvatarUrl,
        "user_activation_key": userActivationKey,
        "noti_token": notiToken,
        "membership_level": membershipLevel,
        "user_dob": dob,
        "user_img": imgurl,
      };
}
