import 'package:flutter/material.dart';
import 'package:lighthouse_planner/dao/task_dao_impl.dart';
import 'package:lighthouse_planner/models/task.dart';
import 'package:lighthouse_planner/tree_handler.dart';
import 'package:lighthouse_planner/ui/widgets/task_container.dart';
import 'package:provider/provider.dart';

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
      treeHandler.setCurrentTask(taskDao.findTask(0), false);
    }
    return Column(
      children: [
        TaskContainer(task: treeHandler.currentTask, isChild: false),
        buildChildren(treeHandler.currentTask),
      ],
    );
  }

  Widget buildChildren(Task tree) {
    if(tree == null) return Container();
    var children = taskDao.findTaskChildren(tree.id);
    if (children.isEmpty) {
      return Divider(
        indent: 50,
        endIndent: 50,
        color: Colors.pink,
        thickness: 1,
      );
    }
    return Column(
      children: children.map((child) {
        return TaskContainer(
            task: child,
            isChild: true,
            updateTreeHandler: () => treeHandler.setCurrentTask(child));
      }).toList(),
    );
  }
}
