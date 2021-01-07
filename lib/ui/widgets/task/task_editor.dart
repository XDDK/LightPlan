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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../app_localizations.dart';
import '../../../dao/task_dao_impl.dart';
import '../../../models/task.dart';
import '../../../utils.dart';
import '../my_container.dart';

class TaskEditor extends StatefulWidget {
  //* Modify the task values, edited Task will result in this.task and his references;
  final Task task;
  final Task parentTask;
  final bool isSubtask;
  final bool buildAddSubtask;
  final bool isEditing;
  final Function addNewTask;
  final Function deleteTask;

  final titleController = TextEditingController();
  final shortDescController = TextEditingController();
  final descController = TextEditingController();

  TaskEditor({
    this.task,
    this.parentTask,
    this.isSubtask = false,
    this.buildAddSubtask = false,
    this.isEditing = false,
    this.addNewTask,
    @required this.deleteTask,
  });

  @override
  _TaskEditor createState() => _TaskEditor();
}

class _TaskEditor extends State<TaskEditor> {
  TaskDaoImpl taskDao;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(TaskEditor oldWidget) {
    if (oldWidget.titleController.text != widget.titleController.text) {
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    widget.titleController.text = widget?.task?.title;
    widget.shortDescController.text = widget?.task?.shortDesc;
    widget.descController.text = widget?.task?.desc;
  }

  @override
  Widget build(BuildContext context) {
    this.taskDao = context.watch<TaskDaoImpl>();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(widget.task),
        SizedBox(height: 10),
        _buildShortDesc(widget.task),
        Divider(thickness: 1),
        _buildRepetition(widget.task),
        _buildDate(widget.task),
        SizedBox(height: 10),
        _buildDesc(widget.task),
        SizedBox(height: widget.buildAddSubtask && widget.isEditing && (widget.task?.canHaveChildren ?? true) ? 0 : 10),
        _buildDeleteSubtask(widget.task, widget.isEditing && widget.isSubtask),
        _buildAddSubtask(widget.task, widget.buildAddSubtask),
      ],
    );
  }

  Widget _buildTitle(Task task) {
    if (widget.isEditing && !widget.task.isPredefined) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth * 0.7,
            child: Material(
              child: TextField(
                maxLength: 15,
                controller: widget.titleController,
                onChanged: (txt) => widget.task.title = txt.trim(),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: AppLocalizations.of(context).translate('editTitle'),
                ),
              ),
            ),
          );
        },
      );
    }
    return Text(
      task?.title ?? "no title yet",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildShortDesc(Task task) {
    if (widget.isEditing) {
      return Material(
        child: TextField(
          maxLength: 170,
          controller: widget.shortDescController,
          onChanged: (txt) => widget.task.shortDesc = txt.trim(),
          textInputAction: TextInputAction.done,
          minLines: 2,
          maxLines: 3,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: AppLocalizations.of(context).translate('editShortDesc'),
          ),
        ),
      );
    }
    return Text(task?.shortDesc ?? "Add a task short description");
  }

  Widget _buildRepetition(Task task) {
    if (task.isPredefined || (!widget.isEditing && task.recurrence == Recurrence.NONE)) return Container();
    List<Recurrence> availableOptions = [Recurrence.NONE, Recurrence.MONTHLY, Recurrence.WEEKLY, Recurrence.DAILY];
    // remove options higher than the first parent_task.with(recurrence != null)
    Task _currentParentTask = taskDao.findTask(task.parentId);
    while (_currentParentTask.recurrence == null) _currentParentTask = taskDao.findTask(_currentParentTask.parentId);
    availableOptions = availableOptions.where((option) {
      return option.index >= _currentParentTask.recurrence.index;
    }).toList();

    // change the current task recurrence if options changed
    task.recurrence = task.recurrence.index < availableOptions[0].index ? availableOptions[0] : task.recurrence;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Task recurrence:"),
              SizedBox(width: 5),
              Visibility(
                visible: !widget.isEditing,
                child: Text(
                  Utils.recurrenceToText(task.recurrence),
                  style: DefaultTextStyle.of(context).style.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Visibility(
                visible: widget.isEditing && !widget.task.isPredefined,
                child: DropdownButton(
                  value: task.recurrence,
                  onChanged: (Recurrence val) => setState(() => task.recurrence = val),
                  items: availableOptions.map((currentSelection) {
                    return DropdownMenuItem<Recurrence>(
                      value: currentSelection,
                      child: Text(Utils.recurrenceToText(currentSelection)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDate(Task task) {
    if (task == null) return Text("error: task is null");
    var now = DateTime.now();
    var lastDate =
        DateTime.fromMillisecondsSinceEpoch(widget.parentTask?.endDate ?? DateTime(now.year).millisecondsSinceEpoch);

    DateTime time;
    if (task.endDate == null) task.endDate = lastDate.millisecondsSinceEpoch;
    time = DateTime.fromMillisecondsSinceEpoch(task.endDate);

    Task _currentTask = task.copyWith();
    while (_currentTask.startDate == null) _currentTask = taskDao.findTask(_currentTask.parentId);
    DateTime startTime = _currentTask.getStartDateTime();

    var df = DateFormat("d MMMM yyyy");
    String dateText = AppLocalizations.of(context).translate('editEndDate');
    List<TextSpan> textSpans = [];

    var functionShowDatePicker = () async {
      if (widget.task.isPredefined) return;
      if (!widget.isEditing) return;
      DateTime selectedTime = await showDatePicker(
        context: context,
        initialDate: time ?? lastDate,
        firstDate: startTime,
        lastDate: lastDate,
      );
      if (selectedTime != null) setState(() => widget.task.endDate = selectedTime.millisecondsSinceEpoch);
    };

    var tapRecognizer = TapGestureRecognizer()..onTap = functionShowDatePicker;

    String selectedDateTxt = AppLocalizations.of(context).translate('editEndDateNotSelected');
    if (time != null) selectedDateTxt = " ${time != null ? df.format(time) : 'no date selected'}";

    // If Task is editing -> predefined (greyed text) or not (blue text)
    // If it's not editing -> only bold date
    if (widget.isEditing) {
      if (widget.task.isPredefined) {
        // bold grey
        textSpans.add(TextSpan(
          text: selectedDateTxt,
          style: DefaultTextStyle.of(context)
              .style
              .copyWith(fontWeight: FontWeight.bold, color: Colors.grey.withOpacity(0.7)),
        ));
      } else {
        // bold blue
        textSpans.add(TextSpan(
          recognizer: tapRecognizer,
          text: selectedDateTxt,
          style: DefaultTextStyle.of(context).style.copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
        ));
      }
    } else {
      // bold
      textSpans.add(TextSpan(
        text: selectedDateTxt,
        style: DefaultTextStyle.of(context).style.copyWith(fontWeight: FontWeight.bold),
      ));
    }

    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          text: dateText,
          style: DefaultTextStyle.of(context).style,
          children: textSpans,
        ),
      ),
    );
  }

  Widget _buildDesc(Task task) {
    if (widget.isEditing) {
      return Material(
        child: TextField(
          maxLength: 250,
          controller: widget.descController,
          onChanged: (txt) => widget.task.desc = txt.trim(),
          textInputAction: TextInputAction.done,
          minLines: 3,
          maxLines: 4,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: AppLocalizations.of(context).translate('editLongDesc'),
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: MyContainer(
        radius: 5,
        color: Color.fromRGBO(0, 0, 0, 0.05),
        padding: EdgeInsets.all(10),
        child: Text(task?.desc ?? "Add a description"),
      ),
    );
  }

  Widget _buildDeleteSubtask(Task task, bool deleteTask) {
    return Visibility(
      visible: deleteTask,
      child: GestureDetector(
        onTap: () {
          // Show confirm Dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).translate('editExit')),
                content: Text(AppLocalizations.of(context).translate('editExitDesc1') + "'${task.title ?? '-'}'" + AppLocalizations.of(context).translate('editExitDesc2')),
                actions: [
                  FlatButton(
                    child: Text(AppLocalizations.of(context).translate('no')),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  FlatButton(
                    child: Text(AppLocalizations.of(context).translate('yes')),
                    onPressed: () async {
                      widget.deleteTask();
                      // Pop dialog box
                      Navigator.of(context).pop(true);
                    },
                  )
                ],
              );
            },
          );
        },
        child: MyContainer(
          height: 36,
          margin: EdgeInsets.only(bottom: 5),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(child: Icon(Icons.delete)),
              Text(AppLocalizations.of(context).translate('editDelete')), 
            ],
          ),
          color: Colors.red,
          colorEffect: true,
          radius: 5,
        ),
      ),
    );
  }

  Widget _buildAddSubtask(Task task, bool buildAddSubtask) {
    // print("$buildAddSubtask $editMode && ${(task?.canHaveChildren ?? true)} && ${widget.isListedAsChild}");
    return Visibility(
      visible: buildAddSubtask,
      child: MyContainer(
        radius: 5,
        color: Theme.of(context).cardColor,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 10),
        ripple: true,
        shadowType: ShadowType.SMALL,
        onTap: widget.addNewTask,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Flexible(
              child: Text(
                AppLocalizations.of(context).translate('editCreate'),
                style: DefaultTextStyle.of(context).style.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}
