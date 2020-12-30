import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dao/task_dao_impl.dart';
import '../../../models/task.dart';
import '../../../tree_handler.dart';
import '../task/task_container.dart';

class TaskTreeContainer extends StatefulWidget {
  final int taskRootId;

  TaskTreeContainer({this.taskRootId});

  @override
  _TaskTreeContainerState createState() => _TaskTreeContainerState();
}

class _TaskTreeContainerState extends State<TaskTreeContainer> {
  TaskDaoImpl taskDao;
  TreeHandler treeHandler;

  Task _rootTask;

  @override
  Widget build(BuildContext context) {
    this.taskDao = context.watch<TaskDaoImpl>();
    this.treeHandler = context.watch<TreeHandler>();

    if (this.taskDao == null) return Container();

    _rootTask = treeHandler.currentRoot;

    if (this._rootTask == null) {
      _rootTask = this.taskDao.findTask(widget.taskRootId);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskContainer(task: _rootTask, isChild: false),
        _buildChildren(_rootTask),
      ],
    );
  }

  Widget _buildChildren(Task rootTask) {
    if (rootTask == null) return Container();
    var children = taskDao.findTaskChildren(rootTask.id);
    if (children.isEmpty) {
      return Divider(indent: 50, endIndent: 50, color: Colors.purple, thickness: 1);
    }
    return Column(
      children: children.map((child) {
        return TaskContainer(task: child, isChild: true);
      }).toList(),
    );
  }
}
