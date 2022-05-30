import 'package:flutter/foundation.dart';

class APIBase {
  static String get baseURL {
    if (kReleaseMode) {
      return "https://myblackhistorycalendar.com/wp-json";
    } else {
      return "https://myblackhistorycalendar.com/wp-json";
    }
  }
}
