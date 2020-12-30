import 'package:flutter/material.dart';

import 'models/task.dart';

class TreeHandler extends ChangeNotifier {
  Task _currentRoot;

  TreeHandler([this._currentRoot]);

  Task get currentRoot {
    return _currentRoot;
  }

  void setCurrentRoot(Task currentTask, [bool notify = true]) {
    this._currentRoot = currentTask;
    if(notify) notifyListeners();
  }
}
