import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse_planner/models/task.dart';
import 'package:lighthouse_planner/ui/widgets/containers/my_container.dart';
import 'package:provider/provider.dart';

class TaskDetailsContainer extends StatefulWidget {
  final Task task;
  final bool editor;
  final bool isListedAsChild;
  final Function updateCurrentTask;

  TaskDetailsContainer({
    this.task,
    @required this.editor,
    this.isListedAsChild,
    @required this.updateCurrentTask,
  });

  @override
  State<StatefulWidget> createState() => _TaskDetailsContainer();
}

class _TaskDetailsContainer extends State<TaskDetailsContainer> {
  double width;
  double height;
  bool editMode;
  List<Task> treeSubTasks = [];

  @override
  void initState() {
    super.initState();

    editMode = widget.task == null ? true : widget.editor;
    treeSubTasks.add(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: MyContainer(
        radius: 10,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(10),
        width: width < 800 ? (width - 20) * 0.8 : width * .3,
        child: Column(
          children: [
            // Stack Task details (title, shortDesc, desc etc) and Edit Button
            Stack(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: treeSubTasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildTaskDetails(treeSubTasks[index], index == 0);
                  },
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => setState(() => editMode = !editMode),
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.all(5),
                      child: FittedBox(child: Icon(Icons.edit)),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
              ],
            ),
            // Delete Button (always visible) and Save Button (visible on edit)
            Visibility(
              visible: editMode,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => print("save"),
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    child: Icon(Icons.save),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // (title, shortDesc, desc etc) add to 'listedTasks' list of widgets
  void _addTaskDetails(Task task) {
    setState(() => treeSubTasks.add(task));
  }

  Widget _buildTaskDetails(Task task, [bool buildAddSubtask = false]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(task),
        _buildShortDesc(task),
        Divider(thickness: 1),
        _buildDate(task),
        SizedBox(height: 10),
        _buildDesc(task),
        SizedBox(
            height:
                buildAddSubtask && editMode && (task?.canHaveChildren ?? true)
                    ? 0
                    : 10),
        _buildAddSubtask(task, buildAddSubtask),
      ],
    );
  }

  final titleController = TextEditingController();
  final shortDescController = TextEditingController();
  final descController = TextEditingController();

  Widget _buildTitle(Task task) {
    if (editMode) {
      return Material(
        child: TextField(
          maxLength: 15,
          controller: titleController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: 'add a funky title',
          ),
        ),
      );
    }
    return Text(
      task?.title ?? "no title yet",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildShortDesc(Task task) {
    return Text(task?.shortDesc ?? "Add a task short description");
  }

  Widget _buildDate(Task task) {
    return Align(
      alignment: Alignment.topRight,
      child: Text(DateTime.fromMillisecondsSinceEpoch(
              task?.endDate ?? DateTime.now().millisecondsSinceEpoch)
          .toString()),
    );
  }

  Widget _buildDesc(Task task) {
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
      visible: buildAddSubtask &&
          editMode &&
          (task?.canHaveChildren ?? true) &&
          widget.isListedAsChild,
      child: MyContainer(
        radius: 5,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(vertical: 10),
        ripple: true,
        shadowType: ShadowType.SMALL,
        onTap: () => print("add a sub task"),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Flexible(
              child: GestureDetector(
                onTap: () => _addTaskDetails(Task.empty()),
                child: Text(
                  "ADD A SUBTASK",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}

class TaskEditor extends StatefulWidget {
  final Task task;
  final bool buildAddSubtree;

  TaskEditor({this.task, this.buildAddSubtree = false});

  @override
  _TaskEditor createState() => _TaskEditor();
}

class _TaskEditor extends State<TaskEditor> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: null,
    );
  }
}
