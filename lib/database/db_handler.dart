import 'package:flutter/material.dart';
import 'package:lighthouse_planner/dao/task_dao_impl.dart';

class DbHandler extends InheritedWidget {
  final TaskDaoImpl taskDao;
  final Widget child;

  DbHandler({this.taskDao, this.child}) : super(child: child);

  static DbHandler of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DbHandler>();
  }

  @override
  bool updateShouldNotify(DbHandler oldWidget) {
    return true;
  }
}
