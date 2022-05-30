//Custom class in project directory
import 'package:flutter/material.dart';

class CommonWidgets {
  CommonWidgets._();
  static buildSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$message"),
      ),
    );
  }
}
