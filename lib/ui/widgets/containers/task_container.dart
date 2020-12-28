import 'package:flutter/material.dart';
import 'package:lighthouse_planner/dao/task_dao_impl.dart';
import 'package:lighthouse_planner/models/task.dart';
import 'package:lighthouse_planner/ui/widgets/containers/my_container.dart';
import 'package:lighthouse_planner/ui/widgets/containers/task_details_container.dart';
import 'package:provider/provider.dart';

class TaskContainer extends StatefulWidget {
  final Task task;
  final bool isChild;
  final int currentTreeHeight;
  final Function updateCurrentTask;

  TaskContainer({
    @required this.task,
    @required this.isChild,
    @required this.currentTreeHeight,
    this.updateCurrentTask,
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

  Widget buildTaskTree() {
    if (widget.isChild)
      return buildChild();
    else
      return buildParent();
  }

  Widget buildChild() {
    return MyContainer(
        radius: 10,
        shadowType: ShadowType.SMALL,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        color: Colors.red,
        onTap: () => widget.updateCurrentTask != null
            ? widget.updateCurrentTask(widget.task)
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(width: 30),

            Expanded(
              child: Column(children: [
                Text(widget.task.title),
                Text(widget.task.shortDesc)
              ]),
            ),
            
            MyContainer(
              onTap: () => _showTaskPreview(widget.task),
              ripple: true,
              shadowType: ShadowType.NONE,
              color: Colors.transparent,
              padding: EdgeInsets.all(5),
              child: Icon(Icons.more_vert),
            ),
          ],
        ));
  }

  Widget buildParent() {
    return MyContainer(
      color: Colors.blue,
      shadowType: ShadowType.SMALL,
      radius: 10,
      width: 300,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Empty container just for formatting. Appears only when main parent is YEAR
          Visibility(
            visible: widget.task.parentId == null,
            child: Container(width: 30),
          ),

          //Back button. Appears only when main parent is != YEAR
          Visibility(
            visible: widget.task.parentId != null,
            child: MyContainer(
              ripple: true,
              color: Colors.transparent,
              child: Icon(Icons.keyboard_backspace),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              onTap: () {
                if (widget.updateCurrentTask != null) {
                  Task parentTask = taskDao.findTask(widget.task.parentId);
                  widget.updateCurrentTask(parentTask);
                }
              },
            ),
          ),

          //Title and Description
          Expanded(
            child: Column(
              children: [
                Text(widget.task.title),
                Text(widget.task.shortDesc)
              ],
            ),
          ),

          //Add (+) button. Appears only when main parent != YEAR
          Visibility(
            visible: widget.currentTreeHeight > 1,
            child: MyContainer(
              onTap: () => _showTaskPreview(widget.task, true),
              ripple: true,
              shadowType: ShadowType.NONE,
              color: Colors.transparent,
              padding: EdgeInsets.all(5),
              child: Icon(Icons.add),
            ),
          ),

          //Menu (three dots :) button.
          MyContainer(
            ripple: true,
            shadowType: ShadowType.NONE,
            color: Colors.transparent,
            child: Icon(Icons.more_vert),
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            onTap: () => _showTaskPreview(widget.task),
          ),
        ],
      ),
    );
  }

  void _showTaskPreview(Task task,
      [bool canAddTask = false, bool editor = false]) async {
    print(
        "TODO // Open Task ${editor ? 'editor' : 'preview'} for ${widget.task.id}");
    await showDialog(
        context: context,
        builder: (_) {
          return Align(
            alignment: Alignment.topCenter,
            child: TaskDetailsContainer(
              task: task,
              editor: true,
              canAddTask: canAddTask,
              updateCurrentTask: widget.updateCurrentTask,
            ),
          );
        });
  }
}
