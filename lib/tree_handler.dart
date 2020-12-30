import 'package:flutter/material.dart';

import 'models/task.dart';

class TreeHandler extends ChangeNotifier {
  Task _root;
  Task _currentRoot;

  TreeHandler([this._currentRoot]) {
    this._root = this._currentRoot;
  }

  Task get currentRoot {
    return _currentRoot;
  }

  Task get root {
    return _root;
  }

  void setCurrentRoot(Task currentTask, [bool notify = true]) {
    this._currentRoot = currentTask;
    if (notify) notifyListeners();
  }

  void setRoot(Task rootTask, [bool notify = true]) {
    this._root = rootTask;
    if (notify) notifyListeners();
  }
}
