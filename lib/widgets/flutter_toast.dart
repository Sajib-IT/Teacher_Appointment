import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlutterToast {
  void toastMessage(
      {required String msg,
      Color bgColor = Colors.blue,
      Color textColor = Colors.white}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: bgColor,
        textColor: textColor,
        fontSize: 18.0);
  }
}
