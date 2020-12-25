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
  String shortDesc;

  @HiveField(4)
  String desc;

  Task({this.id, this.parentId, this.title, this.shortDesc, this.desc});
}