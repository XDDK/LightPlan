import 'package:flutter/material.dart';
import 'package:lighthouse_planner/models/task.dart';

class TaskContainer extends StatefulWidget {
  final Task task;
  final bool isChild;
  final Function updateTreeHandler;

  TaskContainer(
      {@required this.task, @required this.isChild, this.updateTreeHandler});

  @override
  _TaskContainerState createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {

  @override
  Widget build(BuildContext context) {
    if(widget.task == null) return Text(" - current tree is null - ");
    return buildTaskTree();
  }

  Widget buildSelf() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [Text(widget.task.title), Text(widget.task.shortDesc)],
      ),
    );
  }

  Widget buildTaskTree() {
    if (widget.isChild)
      return GestureDetector(
        onTap: () => widget.updateTreeHandler != null ? widget.updateTreeHandler() : null,
        child: buildSelf(),
      );
    else
      return buildSelf();
  }
}
