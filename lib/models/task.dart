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

  Task({
    this.id,
    this.parentId,
    @required this.title,
    @required this.endDate,
    @required this.shortDesc,
    this.desc,
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
