import 'package:flutter/material.dart';
import 'package:lighthouse_planner/models/task.dart';

class TreeHandler extends ChangeNotifier {
  Task _currentTask;

  TreeHandler([this._currentTask]);

  Task get currentTask {
    return _currentTask;
  }

  void setCurrentTask(Task currentTask, [bool notify = true]) {
    this._currentTask = currentTask;
    if(notify) notifyListeners();
  }
}
