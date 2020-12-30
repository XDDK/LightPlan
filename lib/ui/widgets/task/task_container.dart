import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dao/task_dao_impl.dart';
import '../../../models/task.dart';
import '../../../tree_handler.dart';
import '../my_container.dart';
import 'task_popup.dart';

class TaskContainer extends StatefulWidget {
  final Task task;
  final bool isChild;

  TaskContainer({@required this.task, @required this.isChild});

  @override
  _TaskContainerState createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  TaskDaoImpl taskDao;
  TreeHandler treeHandler;

  @override
  Widget build(BuildContext context) {
    this.taskDao = context.watch<TaskDaoImpl>();
    this.treeHandler = context.watch<TreeHandler>();

    if (widget.isChild)
      return buildChild();
    else
      return buildParent();
  }

  void _updateCurrentRoot([Task task]) {
    // If task is null, updade/change the root of the tree
    if (task == null) {
      task = taskDao.findTask(treeHandler.currentRoot.id);
    }
    treeHandler.setCurrentRoot(task);
  }

  Widget buildChild() {
    return GestureDetector(
      onTap: () => _updateCurrentRoot(widget.task),
      child: MyContainer(
        radius: 10,
        shadowType: ShadowType.MEDIUM,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        color: Colors.deepOrange[400],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(width: 30),
            Expanded(
              child: Column(children: [Text(widget.task.title), Text(widget.task.shortDesc)]),
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
        ),
      ),
    );
  }

  Widget buildParent() {
    return MyContainer(
      color: Colors.blue[400],
      shadowType: ShadowType.MEDIUM,
      radius: 10,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Empty container just for formatting. Appears only when main parent is YEAR
          Visibility(
            visible: widget.task.parentId == null,
            child: Container(width: 30),
          ),
          // Back button. Appears only when main parent is != YEAR
          Visibility(
            visible: widget.task.parentId != null,
            child: MyContainer(
              ripple: true,
              color: Colors.transparent,
              child: Icon(Icons.keyboard_backspace),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              onTap: () {
                Task parentTask = taskDao.findTask(widget.task.parentId);
                _updateCurrentRoot(parentTask);
              },
            ),
          ),
          // Title and Description
          Expanded(
            child: Column(
              children: [Text(widget.task.title), Text(widget.task.shortDesc)],
            ),
          ),
          //Add (+) button. Appears only when root of current tree can have children
          Visibility(
            visible: !widget.isChild && widget.task.canHaveChildren,
            child: MyContainer(
              onTap: () => _showTaskPreview(widget.task, true, true),
              ripple: true,
              shadowType: ShadowType.NONE,
              color: Colors.transparent,
              padding: EdgeInsets.all(5),
              child: Icon(Icons.add),
            ),
          ),
          // Menu button
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

  void _showTaskPreview(Task task, [bool canAddTask = false, bool editor = false]) async {
    await showDialog(
        context: context,
        routeSettings: RouteSettings(), // add the dialog on an unnamed route, so user can go back
        builder: (_) {
          return Align(
            alignment: Alignment.topCenter,
            child: TaskPopup(
              task: task,
              editor: editor,
              isListedAsChild: canAddTask,
              taskDao: this.taskDao,
              updateCurrentTask: _updateCurrentRoot,
            ),
          );
        });
  }
}
