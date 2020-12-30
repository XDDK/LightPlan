/*   
*    LightPlan is an open source app created with the intent of helping users keep track of tasks.
*    Copyright (C) 2020-2021 LightPlan Team
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program. If not, see https://www.gnu.org/licenses/.
*
*    Contact the authors at: contact@lightplanx.com
*/

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
