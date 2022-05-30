import 'package:black_history_calender/helper/prefs.dart';

enum APIPath {
  signup,
  signin,
  forgot,
  resetPassword,
  Stories,
  addstories,
  account,
  likesdata,
  postlike,
  calendar,
  comments,
  monthlySubscription,
  mediaUpload,
  addsetting,
  newstories,
  addfavourite,
  validateToken,
  favStories,
  updateDob,
  updateImg
}

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.signup:
        return "/wp/v2/users/register";
      case APIPath.signin:
        return "/jwt-auth/v1/token";
      case APIPath.forgot:
        return "/bdpwr/v1/reset-password";
      case APIPath.resetPassword:
        return "/bdpwr/v1/set-password";
      case APIPath.Stories:
        return "/wp/v2/posts";
      case APIPath.newstories:
        return "/wcra/v1/get_posts/";
      case APIPath.addstories:
        return "/wp/v2/posts";
      case APIPath.account:
        return "/wp/v2/users";
      case APIPath.likesdata:
        return "/wcra/v1/getpostlike/";
      case APIPath.postlike:
        return "/wcra/v1/likepost/";
      case APIPath.calendar:
        return "/wcra/v1/get_posts_by_date/";
      case APIPath.comments:
        return "/wp/v2/comments";
      case APIPath.monthlySubscription:
        return "/pmpro/v1/change_membership_level";
      case APIPath.mediaUpload:
        return "/wp/v2/media";
      case APIPath.addsetting:
        return "/wcra/v1/wp_setting/";
      case APIPath.addfavourite:
        return "/wcra/v1/favourite_post_add/";
      case APIPath.validateToken:
        return "/jwt-auth/v1/token/validate";
      case APIPath.favStories:
        return "/wcra/v1/favourite_post_get/";
      case APIPath.updateDob:
        return "/wcra/v1/add_dob/";
      case APIPath.updateImg:
        return "/wcra/v1/userimage/";
      default:
        return "";
    }
  }
}
