import 'package:flutter/material.dart';
import 'package:lighthouse_planner/dao/task_dao_impl.dart';
import 'package:lighthouse_planner/models/task.dart';
import 'package:provider/provider.dart';

class TaskContainer extends StatefulWidget {
  final Task task;
  final bool isChild;
  final Function updateTreeParent;

  TaskContainer({
    @required this.task,
    @required this.isChild,
    this.updateTreeParent,
  });

  @override
  _TaskContainerState createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  TaskDaoImpl taskDao;

  @override
  Widget build(BuildContext context) {
    if (widget.task == null) return Text(" - current tree is null - ");
    this.taskDao = context.watch<TaskDaoImpl>();

    return buildTaskTree();
  }

  Widget buildChild() {
    return Container(
      padding: EdgeInsets.only(left: 10),
      color: Colors.red,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              children: [Text(widget.task.title), Text(widget.task.shortDesc)]),
          GestureDetector(
            onTap: () {
              print("PRESS");
            },
            child: Icon(
              Icons.menu,
              size: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelf() {
    return Container(
      //padding: EdgeInsets.all(10),
      color: Colors.blue,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.task.parentId != null
              ? GestureDetector(
                  onTap: () {
                    if (widget.updateTreeParent != null) {
                      Task parentTask = taskDao.findTask(widget.task.parentId);
                      widget.updateTreeParent(parentTask);
                    }
                  },
                  child: Icon(
                    Icons.keyboard_backspace,
                    size: MediaQuery.of(context).size.width * 0.04,
                  ),
                )
              : Container(),
          Column(
              children: [Text(widget.task.title), Text(widget.task.shortDesc)]),
          GestureDetector(
            onTap: () {
              print("PRESS");
            },
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
          onTap: () => widget.updateTreeParent != null
              ? widget.updateTreeParent(widget.task)
              : null,
          child: buildChild());
    else
      return buildSelf(context);
  }
}
