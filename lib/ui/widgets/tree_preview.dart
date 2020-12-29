import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dao/task_dao_impl.dart';
import '../../models/task.dart';
import '../../tree_handler.dart';
import 'containers/task_container.dart';

class TreePreview extends StatefulWidget {
  @override
  _TreePreviewState createState() => _TreePreviewState();
}

class _TreePreviewState extends State<TreePreview> {
  TaskDaoImpl taskDao;
  TreeHandler treeHandler;

  @override
  Widget build(BuildContext context) {
    this.taskDao = context.watch<TaskDaoImpl>();
    this.treeHandler = context.watch<TreeHandler>();

    if (this.taskDao == null) return Container();

    if (treeHandler.currentTask == null) {
      treeHandler.setCurrentTask(taskDao.findTaskAt(0), false);
    }
    return IntrinsicWidth(
      child: Column(
        children: [
          TaskContainer(
              task: treeHandler.currentTask,
              isChild: false,
              updateCurrentTask: _updateCurrentTask),
          buildChildren(treeHandler.currentTask),
        ],
      ),
    );
  }

  Widget buildChildren(Task tree) {
    if (tree == null) return Container();
    var children = taskDao.findTaskChildren(tree.id);
    if (children.isEmpty) {
      return Divider(
          indent: 50, endIndent: 50, color: Colors.pink, thickness: 1);
    }
    return Column(
      children: children.map((child) {
        return TaskContainer(
          task: child,
          isChild: true,
          updateCurrentTask: _updateCurrentTask,
        ); // CurrentTask = ChildrenTask
      }).toList(),
    );
  }

  void _updateCurrentTask([Task task]) {
    if (task == null) {
      task = taskDao.findTask(treeHandler.currentTask.id);
    }
    treeHandler.setCurrentTask(task);
  }
}
