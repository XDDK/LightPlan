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
import 'package:hive/hive.dart';

part 'task.g.dart';

enum Recurrence {
  NONE,
  MONTHLY,
  WEEKLY,
  DAILY,
  HOURLY,
}

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  int id;

  @HiveField(1)
  int parentId;

  @HiveField(2)
  String title;

  @HiveField(3)
  int endDate;

  @HiveField(4)
  String shortDesc;

  @HiveField(5)
  String desc;

  @HiveField(6)
  bool isPredefined;

  @HiveField(7)
  bool canHaveChildren;

  @HiveField(8)
  int startDate;

  @HiveField(9)
  int recurrenceIndex;

  Task.empty({int parentId}) {
    this.parentId = parentId;
    this.isPredefined = false;
    this.canHaveChildren = true;
    this.recurrenceIndex = 0;
  }

  Task copyWith({
    int id,
    int parentId,
    String title,
    int endDate,
    String shortDesc,
    String desc,
    bool isPredefined,
    bool canHaveChildren,
    int startDate,
    Recurrence recurrence,
  }) {
    return Task(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      endDate: endDate ?? this.endDate,
      shortDesc: shortDesc ?? this.shortDesc,
      desc: desc ?? this.desc,
      isPredefined: isPredefined ?? this.isPredefined,
      canHaveChildren: canHaveChildren ?? this.canHaveChildren,
      startDate: startDate ?? this.startDate,
      recurrenceIndex: recurrence?.index ?? this.recurrenceIndex,
    );
  }

  Task({
    this.id,
    this.parentId,
    @required this.title,
    @required this.endDate,
    this.shortDesc,
    this.desc,
    @required this.isPredefined,
    this.canHaveChildren = true,
    this.startDate,
    this.recurrenceIndex = 0,
  });

  Task setId(int id) {
    this.id = id;
    return this;
  }

  Recurrence get recurrence {
    return Recurrence.values[this.recurrenceIndex];
  }

  set recurrence(Recurrence recurrence) {
    this.recurrenceIndex = recurrence.index;
  }

  DateTime startDateTime;

  DateTime getStartDateTime() {
    DateTime date = startDateTime;
    if (date == null) {
      date = DateTime.fromMillisecondsSinceEpoch(startDate);
      startDateTime = date;
    }
    return date;
  }

  DateTime endDateTime;

  DateTime getEndDateTime() {
    DateTime date = endDateTime;
    if (date == null) {
      date = DateTime.fromMillisecondsSinceEpoch(endDate);
      endDateTime = date;
    }
    return date;
  }

  Duration tillEndDate() {
    return getEndDateTime().difference(DateTime.now());
  }

  Duration tillEndOfRecurrence() {
    var now = DateTime.now();
    DateTime endRecurrence;
    switch (recurrence) {
      case Recurrence.MONTHLY:
        // end of the current month
        endRecurrence = DateTime(now.year, now.month + 1, 0);
        break;
      case Recurrence.WEEKLY:
        // end of the current week
        endRecurrence = DateTime(now.year, now.month, now.day + (7 - now.weekday));
        break;
      case Recurrence.DAILY:
        // end of the current day
        endRecurrence = DateTime(now.year, now.month, now.day + 1);
        break;
      default:
        // end of the task
        return tillEndDate();
    }
    return endRecurrence.difference(now);
  }

  @override
  String toString() {
    return "Task[id=$id,parentId=$parentId,title=$title,startDate=$startDate,endDate=$endDate,shortDesc=$shortDesc,desc=$desc";
  }
}
