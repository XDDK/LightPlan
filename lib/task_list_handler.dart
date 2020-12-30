import 'package:flutter/material.dart';

class TaskListHandler extends ChangeNotifier {
  int _taskRootCount;

  TaskListHandler([this._taskRootCount]);

  int get taskRootCount {
    return _taskRootCount;
  }

  void setTaskRootCount(int taskRootCount, [bool notify = true]) {
    _taskRootCount = taskRootCount;
    if (notify) notifyListeners();
  }
}
