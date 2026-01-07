import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AppToast {
  static void show(
      String message, {
        ToastGravity gravity = ToastGravity.BOTTOM,
        Color bgColor = Colors.black87,
        Color textColor = Colors.white,
      }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 14,
    );
  }
}
