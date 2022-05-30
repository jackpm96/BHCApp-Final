// class SignupResponse {
//   int id;
//   String username;
//   String name;
//   String firstName;
//   String lastName;
//   String email;
//   String url;
//   String description;
//   String link;
//   String locale;
//   String nickname;
//   String slug;
//   List<String> roles;
//   String registeredDate;
//   Capabilities capabilities;
//   ExtraCapabilities extraCapabilities;
//   AvatarUrls avatarUrls;

//   SignupResponse({
//     this.id,
//     this.username,
//     this.name,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.url,
//     this.description,
//     this.link,
//     this.locale,
//     this.nickname,
//     this.slug,
//     this.roles,
//     this.registeredDate,
//     this.capabilities,
//     this.extraCapabilities,
//     this.avatarUrls,
//   });

//   SignupResponse.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     name = json['name'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     email = json['email'];
//     url = json['url'];
//     description = json['description'];
//     link = json['link'];
//     locale = json['locale'];
//     nickname = json['nickname'];
//     slug = json['slug'];
//     roles = json['roles'].cast<String>();
//     registeredDate = json['registered_date'];
//     capabilities = json['capabilities'] != null
//         ? new Capabilities.fromJson(json['capabilities'])
//         : null;
//     extraCapabilities = json['extra_capabilities'] != null
//         ? new ExtraCapabilities.fromJson(json['extra_capabilities'])
//         : null;
//     avatarUrls = json['avatar_urls'] != null
//         ? new AvatarUrls.fromJson(json['avatar_urls'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['username'] = this.username;
//     data['name'] = this.name;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['email'] = this.email;
//     data['url'] = this.url;
//     data['description'] = this.description;
//     data['link'] = this.link;
//     data['locale'] = this.locale;
//     data['nickname'] = this.nickname;
//     data['slug'] = this.slug;
//     data['roles'] = this.roles;
//     data['registered_date'] = this.registeredDate;
//     if (this.capabilities != null) {
//       data['capabilities'] = this.capabilities.toJson();
//     }
//     if (this.extraCapabilities != null) {
//       data['extra_capabilities'] = this.extraCapabilities.toJson();
//     }
//     if (this.avatarUrls != null) {
//       data['avatar_urls'] = this.avatarUrls.toJson();
//     }
//     return data;
//   }
// }

// class Capabilities {
//   bool read;
//   bool level0;
//   bool subscriber;

//   Capabilities({this.read, this.level0, this.subscriber});

//   Capabilities.fromJson(Map<String, dynamic> json) {
//     read = json['read'];
//     level0 = json['level_0'];
//     subscriber = json['subscriber'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['read'] = this.read;
//     data['level_0'] = this.level0;
//     data['subscriber'] = this.subscriber;
//     return data;
//   }
// }

// class ExtraCapabilities {
//   bool subscriber;

//   ExtraCapabilities({this.subscriber});

//   ExtraCapabilities.fromJson(Map<String, dynamic> json) {
//     subscriber = json['subscriber'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['subscriber'] = this.subscriber;
//     return data;
//   }
// }

// class AvatarUrls {
//   String s24;
//   String s48;
//   String s96;

//   AvatarUrls({this.s24, this.s48, this.s96});

//   AvatarUrls.fromJson(Map<String, dynamic> json) {
//     s24 = json['24'];
//     s48 = json['48'];
//     s96 = json['96'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['24'] = this.s24;
//     data['48'] = this.s48;
//     data['96'] = this.s96;
//     return data;
//   }
// }

class SignupResponse {
  int code;
  String message;

  SignupResponse({this.code, this.message});

  SignupResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}
