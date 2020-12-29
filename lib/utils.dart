import 'package:flutter/material.dart';

class Utils {
  static void showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black.withOpacity(0.7),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      duration: Duration(seconds: 3),
      width: 200,
      behavior: SnackBarBehavior.floating,
    ));
    /* fToast.showToast(
      child: MyContainer(
        color: Colors.black.withOpacity(0.5),
        radius: 15,
        padding: EdgeInsets.all(10),
        child: Text(msg, style: TextStyle(color: Colors.white)),
      ),
      gravity: ToastGravity.BOTTOM,
    ); */
  }
}
