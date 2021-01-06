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

import 'models/task.dart';
import 'theme_handler.dart';

class Utils {
  static Map<int, List<Task>> _defaultTasks = {};
  /// index 0=year, 1=q1, 2=q2, 3=q3, 4=q4
  static List<Task> getTaskDefaults(int year) {
    if(_defaultTasks[year] != null) return _defaultTasks[year];
    Task yearTask = Task(
        title: "$year",
        startDate: DateTime(year, 1, 1).millisecondsSinceEpoch,
        endDate: DateTime(year, 12, 31, 24).millisecondsSinceEpoch,
        isPredefined: true,
        canHaveChildren: false,
        shortDesc: "New year new me, right?",
        desc: "Get a car, quit smoking, be healthy. I think you got it!");
    Task quarter1 = Task(
        title: "January - March",
        startDate: DateTime(year, 1, 1).millisecondsSinceEpoch,
        endDate: DateTime(year, 3, 31, 24).millisecondsSinceEpoch,
        isPredefined: true,
        shortDesc: "Stuff we do in spring",
        desc: "blah blah");
    Task quarter2 = Task(
        title: "April - June",
        startDate: DateTime(year, 4, 1).millisecondsSinceEpoch,
        endDate: DateTime(year, 6, 30, 24).millisecondsSinceEpoch,
        isPredefined: true,
        shortDesc: "Stuff we do in summer",
        desc: "blah blah");
    Task quarter3 = Task(
        title: "July - September",
        startDate: DateTime(year, 7, 1).millisecondsSinceEpoch,
        endDate: DateTime(year, 9, 30, 24).millisecondsSinceEpoch,
        isPredefined: true,
        shortDesc: "Stuff we do in autumn",
        desc: "blah blah");
    Task quarter4 = Task(
        title: "Octomber - December",
        startDate: DateTime(year, 10, 1).millisecondsSinceEpoch,
        endDate: DateTime(year, 12, 31, 24).millisecondsSinceEpoch,
        isPredefined: true,
        shortDesc: "Stuff we do in winter",
        desc: "blah blah");
    _defaultTasks[year] = [yearTask, quarter1, quarter2, quarter3, quarter4];
    return _defaultTasks[year];
  }

  static String recurrenceToText(Recurrence repetition) {
    String text;
    switch (repetition) {
      case Recurrence.MONTHLY:
        text = "monthly";
        break;
      case Recurrence.WEEKLY:
        text = "weekly";
        break;
      case Recurrence.DAILY:
        text = "daily";
        break;
      case Recurrence.HOURLY:
        text = "hourly";
        break;
      default:
        text = "none";
        break;
    }
    return text;
  }

  static void showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: themeHandler.baseColor()),
      ),
      backgroundColor: themeHandler.baseColor(true).withOpacity(0.7),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      duration: Duration(seconds: 3),
      width: 200,
      behavior: SnackBarBehavior.floating,
    ));
  }
}
