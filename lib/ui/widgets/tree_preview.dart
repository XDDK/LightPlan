import 'package:flutter/material.dart';
import 'package:lighthouse_planner/dao/task_dao_impl.dart';
import 'package:lighthouse_planner/models/task.dart';
import 'package:provider/provider.dart';

class TreePreview extends StatefulWidget {
  @override
  _TreePreviewState createState() => _TreePreviewState();
}

class _TreePreviewState extends State<TreePreview> {
  TaskDaoImpl taskDao;

  @override
  Widget build(BuildContext context) {
    this.taskDao = Provider.of<TaskDaoImpl>(context);
    if(this.taskDao == null) return Container();
    // this.taskDao = context.watch<TaskDaoImpl>();
    Task firstTask = taskDao.findTask(0);
    if (firstTask == null) return Text("Tree is null");
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
    var children = taskDao.findTaskChildren(tree.id);
    if (children.isEmpty)
      return Text(
        "•",
        style: TextStyle(color: Colors.pink),
      );
    return Column(
        children: children.map((child) {
      return buildSelf(child);
    }).toList());
  }
}
