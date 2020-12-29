import 'package:flutter/material.dart';

import '../../../models/task.dart';
import 'my_container.dart';

class TaskEditor extends StatefulWidget {
  final Task task;
  final bool buildAddSubtask;
  final bool isEditing;
  final Function addNewTask;

  final titleController = TextEditingController();
  final Map<int, int> dateMap = Map();
  final shortDescController = TextEditingController();
  final descController = TextEditingController();

  TaskEditor({
    this.task,
    this.buildAddSubtask = false,
    this.isEditing = false,
    this.addNewTask,
  });

  String get title => titleController.text;
  int get date => dateMap[0];
  String get shortDesc => shortDescController.text;
  String get desc => descController.text;

  Task getEditedTask() {
    return this.task.copyWith(
          title: this.title,
          endDate: this.date,
          shortDesc: this.shortDesc,
          desc: this.desc,
        );
  }

  @override
  _TaskEditor createState() => _TaskEditor();
}

class _TaskEditor extends State<TaskEditor> {
  var titleController = TextEditingController();
  var dateMap = Map<int, int>();
  var shortDescController = TextEditingController();
  var descController = TextEditingController();

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
    widget.dateMap[0] = widget?.task?.endDate;
  }

  @override
  Widget build(BuildContext context) {
    // on is the way;
    // print("widget.titlecontrl.text=${widget.titleController.text}; widget.datemap[0]=${widget.dateMap[0]}");
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
    DateTime time;
    DateTime now = DateTime.now();
    if (widget.isEditing) {
      time = DateTime.fromMillisecondsSinceEpoch(widget.dateMap[0] ?? now.millisecondsSinceEpoch);
    } else {
      time = DateTime.fromMillisecondsSinceEpoch(task?.endDate ?? now.millisecondsSinceEpoch);
    }
    widget.dateMap[0] = time.millisecondsSinceEpoch;
    // print("${DateTime.fromMillisecondsSinceEpoch(widget.dateMap[0])} before selection");
    return Align(
      alignment: Alignment.topRight,
      child: IgnorePointer(
        ignoring: widget.task.isPredefined,
        child: GestureDetector(
          onTap: () async {
            if (!widget.isEditing) return;
            DateTime selectedTime = await showDatePicker(
              context: context,
              initialDate: time,
              firstDate: DateTime(2000),
              lastDate: DateTime(time.year + 1),
            );
            if (selectedTime != null) setState(() => widget.dateMap[0] = selectedTime.millisecondsSinceEpoch);
            // print("${DateTime.fromMillisecondsSinceEpoch(widget.dateMap[0])} after selection");
          },
          child: Text(time.toString()),
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
                "ADD A SUBTASK",
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
