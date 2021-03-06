/*   
*    LightPlan is an open source app created with the intent of helping users keep track of tasks.
*    Copyright (C) 2020-2021 LightPlan Team
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program. If not, see https://www.gnu.org/licenses/.
*
*    Contact the authors at: contact@lightplanx.com
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dao/preferences.dart';
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

  void _updateCurrentRoot([Task task]) async {
    // If task is null, updade/change the root of the tree
    if (task == null) {
      task = taskDao.findTask(treeHandler.currentRoot.id);
    }
    treeHandler.setCurrentRoot(task);
    await Preferences.getFutureInstance();
    Preferences.getInstance().setLastViewedTask(task.id);
    Preferences.getInstance().setLastViewedYear(treeHandler.root.getEndDateTime().year - 1);
  }

  Widget buildChild() {
    Color widgetColor = Colors.deepOrange[400];
    Duration tillRecurrence = widget.task.tillEndOfRecurrence();
    Duration tillEndDate = widget.task.tillEndDate();
    Duration result = tillRecurrence.compareTo(tillEndDate) < 0 ? tillRecurrence : tillEndDate;
    if (result.isNegative) {
      widgetColor = Colors.redAccent;
    } else if (result.inHours < 24 && result.inHours >= 6) {
      widgetColor = Colors.red[500];
    } else if (result.inHours < 6) {
      widgetColor = Colors.red[900];
    }

    return GestureDetector(
      onTap: () => _updateCurrentRoot(widget.task),
      child: MyContainer(
          radius: 10,
          shadowType: ShadowType.MEDIUM,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          color: widgetColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 30),
              Expanded(
                child: Column(
                  children: [
                    Text(widget.task.title, textAlign: TextAlign.center),
                    Divider(thickness: 1),
                    Visibility(
                      visible: widget.task?.desc != null,
                      child: Text(_formatDescPreview(widget.task?.desc) ?? "", textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
              MyContainer(
                onTap: () => _showTaskPreview(widget.task),
                ripple: true,
                shadowType: ShadowType.NONE,
                color: Colors.transparent,
                padding: EdgeInsets.all(5),
                child: Icon(Icons.more_vert, size: 30),
              ),
            ],
          )),
    );
  }

  Widget buildParent() {
    return MyContainer(
        color: Colors.blue[400],
        shadowType: ShadowType.MEDIUM,
        radius: 10,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            // HOME and BACK buttons
            Visibility(
              visible: widget.task.parentId == null,
              child: Container(width: 30),
            ),
            Column(
              children: [
                _buildIcon(
                  widget.task.parentId != null,
                  Icons.home_outlined,
                  () => _updateCurrentRoot(treeHandler.root),
                ),
                _buildIcon(
                  widget.task.parentId != null,
                  Icons.keyboard_backspace,
                  () {
                    Task parentTask = taskDao.findTask(widget.task.parentId);
                    _updateCurrentRoot(parentTask);
                  },
                ),
              ],
            ),
            // Title and desc
            Expanded(
              child: Column(
                children: [
                  Text(widget.task.title, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  Divider(thickness: 1),
                  Visibility(
                    visible: widget.task?.desc != null,
                    child: Text(_formatDescPreview(widget.task?.desc) ?? "", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            // MORE and CREATE buttons
            Column(
              children: [
                _buildIcon(
                  true,
                  Icons.more_vert,
                  () => _showTaskPreview(widget.task),
                ),
                _buildIcon(
                  !widget.isChild && widget.task.canHaveChildren,
                  Icons.add,
                  () => _showTaskPreview(widget.task, true, true),
                ),
              ],
            ),
          ],
        ));
  }

  /// Returns the first 75 characters followed by '...'
  String _formatDescPreview(String desc) {
    if(desc != null) {
      if(desc.length > 75)
        return "${desc.substring(0, 75)}...";
    }
    return desc;
  }

  Widget _buildIcon(bool visible, IconData icon, Function onTap) {
    return Visibility(
      visible: visible,
      child: MyContainer(
        onTap: onTap,
        ripple: true,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        child: FittedBox(
          child: Icon(icon, size: 30),
        ),
      ),
    );
  }

  void _showTaskPreview(Task task, [bool canAddTask = false, bool editor = false]) async {
    await showDialog(
        context: context,
        routeSettings: RouteSettings(), // add the dialog on an unnamed route, so user can go back
        builder: (_) {
          return Provider(
            create: (_) => TaskDaoImpl.getInstance(),
            child: Align(
              alignment: Alignment.topCenter,
              child: TaskPopup(
                task: task,
                editor: editor,
                isListedAsChild: canAddTask,
                taskDao: this.taskDao,
                updateCurrentTask: _updateCurrentRoot,
              ),
            ),
          );
        });
  }
}
