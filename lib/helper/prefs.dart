import 'package:black_history_calender/helper/const.dart';
import 'package:black_history_calender/screens/auth/model/stories_response.dart';

import 'preference_helper.dart';

class Prefs {
  static Future<String> get id => PreferencesHelper.getString(Const.ID);
  static Future setID(String value) =>
      PreferencesHelper.setString(Const.ID, value);

  static Future<String> get userName =>
      PreferencesHelper.getString(Const.USER_NAME);
  static Future setUserName(String value) =>
      PreferencesHelper.setString(Const.USER_NAME, value);

  static Future<String> get name => PreferencesHelper.getString(Const.NAME);
  static Future setName(String value) =>
      PreferencesHelper.setString(Const.NAME, value);

  static Future<String> get userLogin =>
      PreferencesHelper.getString(Const.user_login);
  static Future setUserLogin(String value) =>
      PreferencesHelper.setString(Const.user_login, value);

  static Future<String> get firstName =>
      PreferencesHelper.getString(Const.FIRST_NAME);
  static Future setFirstName(String value) =>
      PreferencesHelper.setString(Const.FIRST_NAME, value);

  static Future<String> get lastName =>
      PreferencesHelper.getString(Const.LAST_NAME);
  static Future setLastName(String value) =>
      PreferencesHelper.setString(Const.LAST_NAME, value);

  static Future<String> get token => PreferencesHelper.getString(Const.Token);
  static Future setToken(String value) =>
      PreferencesHelper.setString(Const.Token, value);

  static Future<String> get email => PreferencesHelper.getString(Const.Email);
  static Future setEmail(String value) =>
      PreferencesHelper.setString(Const.Email, value);

  static Future<String> get membership =>
      PreferencesHelper.getString(Const.Membership);
  static Future setMembership(String value) =>
      PreferencesHelper.setString(Const.Membership, value);

  // static Future<String> get image_url => PreferencesHelper.getString(Const.Image_url);
  // static Future setImage_url(String value) =>
  //     PreferencesHelper.setString(Const.Image_url, value);

  static Future<bool> get rememberMe =>
      PreferencesHelper.getBool(Const.REMEMBER);
  static Future setRememberMe(bool value) =>
      PreferencesHelper.setBool(Const.REMEMBER, value);

  static Future<bool> get notiStatus =>
      PreferencesHelper.getBool(Const.NotiStatus);
  static Future setNotiStatus(bool value) =>
      PreferencesHelper.setBool(Const.NotiStatus, value);

  static Future<bool> get emailStatus =>
      PreferencesHelper.getBool(Const.EmailStatus);
  static Future setEmailStatus(bool value) =>
      PreferencesHelper.setBool(Const.EmailStatus, value);

  static Future<String> get readingStories =>
      PreferencesHelper.getString(Const.ConReading);
  static Future setReadingStories(String value) =>
      PreferencesHelper.setString(Const.ConReading, value);

  static Future<String> get subsRole =>
      PreferencesHelper.getString(Const.SubsRole);
  static Future setSubsRole(String value) =>
      PreferencesHelper.setString(Const.SubsRole, value);

  static Future<bool> get manageTouch =>
      PreferencesHelper.getBool(Const.ManageTouch);
  static Future setManageTouch(bool value) =>
      PreferencesHelper.setBool(Const.ManageTouch, value);

  static Future<String> get dob => PreferencesHelper.getString(Const.dob);
  static Future setDob(String value) =>
      PreferencesHelper.setString(Const.dob, value);

  static Future<String> get imgurl => PreferencesHelper.getString(Const.imgurl);
  static Future setImg(String value) =>
      PreferencesHelper.setString(Const.imgurl, value);

  Future<void> clear() async {
    await Future.wait(<Future>[
      setID(''),
      setUserName(''),
      setName(''),
      setFirstName(''),
      setLastName(''),
      setToken(''),
      setSubsRole(''),
      setDob(''),
      setImg(''),
      setRememberMe(false),
      setNotiStatus(false),
      setEmailStatus(false),
      setManageTouch(false)
    ]);
  }
}
