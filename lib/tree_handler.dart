import 'package:lighthouse_planner/models/task.dart';

class TreeHandler {
  Task _currentTask;

  TreeHandler([this._currentTask]);

  Task get currentTask {
    return _currentTask;
  }

  void setCurrentTask(Task currentTask) {
    this._currentTask = currentTask;
  }
}
