import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/task.dart';
import '../my_container.dart';

class TaskEditor extends StatefulWidget {
  //* Modify the task values, edited Task will result in this.task and his references;
  final Task task;
  final Task parentTask;
  final bool buildAddSubtask;
  final bool isEditing;
  final Function addNewTask;

  final titleController = TextEditingController();
  final shortDescController = TextEditingController();
  final descController = TextEditingController();

  TaskEditor({
    this.task,
    this.parentTask,
    this.buildAddSubtask = false,
    this.isEditing = false,
    this.addNewTask,
  });

  @override
  _TaskEditor createState() => _TaskEditor();
}

class _TaskEditor extends State<TaskEditor> {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(widget.task),
        SizedBox(height: 10),
        _buildShortDesc(widget.task),
        Divider(thickness: 1),
        _buildDate(widget.task),
        SizedBox(height: 10),
        _buildDesc(widget.task),
        SizedBox(height: widget.buildAddSubtask && widget.isEditing && (widget.task?.canHaveChildren ?? true) ? 0 : 10),
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
                  hintText: 'Add a funky title',
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
            hintText: 'Write just a summary description... this will be the preview',
          ),
        ),
      );
    }
    return Text(task?.shortDesc ?? "Add a task short description");
  }

  Widget _buildDate(Task task) {
    DateTime now = DateTime.now();
    DateTime time;
    if (task?.endDate != null) time = DateTime.fromMillisecondsSinceEpoch(task.endDate);

    var df = DateFormat("d MMMM yyyy");
    String dateText = "This will end on:";
    List<TextSpan> textSpans = [];

    var functionShowDatePicker = () async {
      if (widget.task.isPredefined) return;
      if (!widget.isEditing) return;
      var lastDate =
          DateTime.fromMillisecondsSinceEpoch(widget.parentTask?.endDate ?? DateTime(now.year).millisecondsSinceEpoch);
      DateTime selectedTime = await showDatePicker(
        context: context,
        initialDate: time ?? lastDate,
        firstDate: DateTime(2000),
        lastDate: lastDate,
      );
      if (selectedTime != null) setState(() => widget.task.endDate = selectedTime.millisecondsSinceEpoch);
    };

    var tapRecognizer = TapGestureRecognizer()..onTap = functionShowDatePicker;

    String selectedDateTxt = " no date selected";
    if (time != null) selectedDateTxt = "${time != null ? df.format(time) : 'no date selected'}";

    // If Task is editing -> predefined (greyed text) or not (blue text)
    // If it's not editing -> only bold date
    if (widget.isEditing) {
      if (widget.task.isPredefined) {
        // bold grey
        textSpans.add(TextSpan(
          text: selectedDateTxt,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.withOpacity(0.7)),
        ));
      } else {
        // bold blue
        textSpans.add(TextSpan(
          recognizer: tapRecognizer,
          text: selectedDateTxt,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ));
      }
    } else {
      // bold
      textSpans.add(TextSpan(
        text: selectedDateTxt,
        style: TextStyle(fontWeight: FontWeight.bold),
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
            hintText:
                'Here you can write more, add details until 250 characters.\nYes, you also need to summarize this.',
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

  Widget _buildAddSubtask(Task task, bool buildAddSubtask) {
    // print("$buildAddSubtask $editMode && ${(task?.canHaveChildren ?? true)} && ${widget.isListedAsChild}");
    return Visibility(
      visible: buildAddSubtask,
      child: MyContainer(
        radius: 5,
        color: Colors.white,
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
                "CREATE A SUBTASK",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}
