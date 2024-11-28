import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMsg{

  static void showMsg(String msg){
      Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.blue.shade200,
        webPosition: "center",
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
      );
  }


}