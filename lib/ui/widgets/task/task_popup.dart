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
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../dao/task_dao_impl.dart';
import '../../../models/task.dart';
import '../../../utils.dart';
import '../my_container.dart';
import 'task_editor.dart';

class TaskPopup extends StatefulWidget {
  final Task task;
  final bool editor;
  final bool isListedAsChild;
  final TaskDaoImpl taskDao;
  final Function updateCurrentTask;

  TaskPopup({
    this.task,
    @required this.editor,
    this.isListedAsChild,
    @required this.taskDao,
    @required this.updateCurrentTask,
  });

  @override
  State<StatefulWidget> createState() => _TaskDetailsContainer();
}

class _TaskDetailsContainer extends State<TaskPopup> {
  double width, height;
  bool editMode;
  List<Task> editingTasks = [];

  @override
  void initState() {
    super.initState();

    editingTasks.clear();
    editingTasks.add(widget.task.copyWith());

    editMode = widget.editor;
    if(editMode == true) {
      this._addSubtask();
    }
  }

  @override
  void didUpdateWidget(TaskPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    this.width = MediaQuery.of(context).size.width;
    this.height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => _showConfirmQuit(),
      child: SingleChildScrollView(
        child: KeyboardVisibilityBuilder(builder: (_, isKeyboardVisible) {
          return MyContainer(
            radius: 10,
            padding: EdgeInsets.all(20),
            //* MediaQuery.of(context).viewInsets.bottom = 0 on mobile web
            margin:
                EdgeInsets.fromLTRB(10, 10, 10, isKeyboardVisible ? 10 + MediaQuery.of(context).viewInsets.bottom : 10),
            color: Colors.white,
            width: width < 800 ? (width - 20) * 0.8 : width * .3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Stack Task details (title, shortDesc, desc etc) and Edit Button
                Stack(
                  children: [
                    //Preview UI: show current task details
                    ListView.builder(
                      // ! Important so, the entire container can be scrollable (from within, not only edges)
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: editingTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskEditor(
                          task: editingTasks[index],
                          parentTask: widget.taskDao.findTask(editingTasks[index].parentId),
                          isSubtask: index > 0,
                          buildAddSubtask: index == 0 &&
                              editMode &&
                              (editingTasks[index]?.canHaveChildren ?? true) &&
                              widget.isListedAsChild,
                          isEditing: editMode,
                          addNewTask: _addSubtask,
                          deleteTask: () {
                            setState(() => editingTasks.removeAt(index));
                          },
                        );
                      },
                    ),
                    // Edit Button
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          var quit = await _showConfirmQuit();
                          if (quit) {
                            editingTasks.clear();
                            editingTasks.add(widget.task.copyWith());
                            setState(() => editMode = !editMode);
                          }
                        },
                        child: Container(
                          height: 30,
                          padding: EdgeInsets.all(5),
                          child: FittedBox(child: Icon(editMode ? Icons.cancel : Icons.edit)),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                    ),
                  ],
                ),
                // Delete Button (always visible on !isPredefined tasks) and Save Button (visible on edit)
                Row(
                  children: [
                    Visibility(
                      visible: !widget.task.isPredefined,
                      child: Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Show confirm Dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Are you sure?"),
                                  content: Text("Task with title '${widget.task.title}' will be deleted."),
                                  actions: [
                                    FlatButton(
                                      child: Text("Cancel"),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    FlatButton(
                                      child: Text("Delete"),
                                      onPressed: () async {
                                        await widget.taskDao.deleteTask(widget.task);
                                        widget.updateCurrentTask(widget.taskDao.findTask(widget.task.parentId));
                                        // Pop dialog box
                                        Navigator.of(context).pop(true);
                                        // Pop task details
                                        Navigator.of(context).pop(true);
                                        Utils.showToast(context, "'${widget.task.title}' task deleted.");
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: MyContainer(
                            height: 35,
                            child: Icon(Icons.delete),
                            color: Colors.red,
                            colorEffect: true,
                            radius: 5,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: editMode && !widget.task.isPredefined,
                      child: SizedBox(width: 10),
                    ),
                    Visibility(
                      visible: editMode,
                      child: Expanded(
                        child: GestureDetector(
                          onTap: () => _saveTaskTree(),
                          child: MyContainer(
                            height: 35,
                            child: Icon(Icons.save),
                            color: Colors.green,
                            colorEffect: true,
                            radius: 5,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  // (title, shortDesc, desc etc) add to 'listedTasks' list of widgets
  void _addSubtask() {
    setState(() => editingTasks.add(Task.empty(parentId: widget.task.id)));
  }

  bool _checkInvalidTasks() {
    bool isInvalid = false;
    for (var task in editingTasks) {
      if (task.title == null || task.title.isEmpty) isInvalid = true;
      if (task.shortDesc == null || task.shortDesc.isEmpty) isInvalid = true;
      if (task.endDate == null) isInvalid = true;
    }
    return isInvalid;
  }

  Future<void> _saveTaskTree() async {
    if (_checkInvalidTasks()) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Title / Short Description / Date missing"),
            content: Text("The app had a purpose. 😳"),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
      return;
    }

    for (var editingTask in editingTasks) {
      await widget.taskDao.insertOrUpdate(editingTask);
    }

    widget.updateCurrentTask();
    editMode = false;

    // Close Popup Task Details
    Navigator.of(context).pop();

    Utils.showToast(context, "${editingTasks.length} task(s) saved/updated.");
  }

  Future<bool> _showConfirmQuit() async {
    if (!editMode) return true;
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to exit edit mode?'),
          content: Text("You will lose all the modifications."),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
