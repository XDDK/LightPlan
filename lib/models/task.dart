import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

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

  Task.empty({int parentId}) {
    this.endDate = DateTime.now().millisecondsSinceEpoch;
    this.parentId = parentId;
    this.isPredefined = false;
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
    );
  }

  Task({
    this.id,
    this.parentId,
    @required this.title,
    @required this.endDate,
    @required this.shortDesc,
    this.desc,
    @required this.isPredefined,
    this.canHaveChildren = true,
  });

  Task setId(int id) {
    this.id = id;
    return this;
  }

  @override
  String toString() {
    return "Task[id=$id,parentId=$parentId,title=$title,endDate=$endDate,shortDesc=$shortDesc,desc=$desc";
  }
}
