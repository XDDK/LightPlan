import 'package:flutter/material.dart';
import 'package:lighthouse_planner/dao/task_dao_impl.dart';
import 'package:lighthouse_planner/database/db_handler.dart';
import 'package:lighthouse_planner/models/task.dart';

class TreePreview extends StatelessWidget {
  TaskDaoImpl taskDao;

  @override
  Widget build(BuildContext context) {
    this.taskDao = DbHandler.of(context).taskDao;
    Task firstTask = taskDao.findTask(0);
    // if (this.currentTask == null) return Text("Tree is null");
    return Column(
      children: [
        buildSelf(firstTask),
        buildChildren(firstTask),
      ],
    );
  }

  Widget buildSelf(Task tree) {
    if (tree == null) return Text(" - current tree is null - ");
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [Text(tree.title), Text(tree.shortDesc)],
      ),
    );
  }

  Widget buildChildren(Task tree) {
    // return Text("todo // children");
    var children = taskDao.findTaskChildren(tree.id);
    if (children.isEmpty) return Text("•", style: TextStyle(color: Colors.pink));
    return Column(
        children: children.map((child) {
      return buildSelf(child);
    }).toList());
  }
}
