import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonWidgets{
  //Custom Toast Mesaj Gösterimi
  customToast(String toastMessage, Color toastColor) async {
    Fluttertoast.showToast(
        msg: toastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: toastColor,
        textColor: Colors.white,
        fontSize: 16.0);
    await Future.delayed(Duration(milliseconds: 350));
  }

}