import 'package:flutter/material.dart';
import '../../../models/task.dart';
import 'my_container.dart';

import 'task_editor.dart';

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
  double width, height;
  bool editMode;
  List<Task> treeSubTasks = [];
  List<TaskEditor> taskEditors = [];

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

    taskEditors.clear();

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
                    var te = TaskEditor(
                      task: treeSubTasks[index],
                      buildAddSubtask: index == 0 &&
                          editMode &&
                          (treeSubTasks[index]?.canHaveChildren ?? true) &&
                          widget.isListedAsChild,
                      isEditing: editMode,
                      addNewTask: () => _addTaskDetails(Task.empty(parentId: widget.task.id)),
                    );
                    taskEditors.add(te);
                    return te;
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
                      child: FittedBox(child: Icon(editMode ? Icons.cancel : Icons.edit)),
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
                  onTap: () => _saveTaskTree(),
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

  void _saveTaskTree() {
    for(var te in taskEditors)  {
      print(te.getEditedTask());
    }
  }
}