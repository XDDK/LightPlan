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
    return buildTaskTree(context);
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      color: Colors.red,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [Text(widget.task.title), Text(widget.task.shortDesc)]),
          GestureDetector(
            onTap: () { print("PRESS"); },
            child: Icon(
              Icons.menu,
              size: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelf(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),
      color: Colors.blue,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () { print("BACK"); },
            child: Icon(
              Icons.keyboard_backspace,
              size: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
          Column(children: [Text(widget.task.title), Text(widget.task.shortDesc)]),
          GestureDetector(
            onTap: () { print("PRESS"); },
            child: Icon(
              Icons.menu,
              size: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTaskTree(BuildContext context) {
    if (widget.isChild)
      return GestureDetector(
        onTap: () => widget.updateTreeHandler != null
            ? widget.updateTreeHandler()
            : null,
        child: buildChild(context)
      );
    else
      return buildSelf(context);
  }
}
