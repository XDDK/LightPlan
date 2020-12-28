import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse_planner/models/task.dart';
import 'package:lighthouse_planner/ui/widgets/containers/my_container.dart';

class TaskDetailsContainer extends StatefulWidget {
  final Task task;
  final bool editor;
  final bool canAddTask;
  final Function updateCurrentTask;

  TaskDetailsContainer({
    this.task,
    @required this.editor,
    @required this.canAddTask,
    @required this.updateCurrentTask,
  });

  @override
  State<StatefulWidget> createState() => _TaskDetailsContainer();
}

class _TaskDetailsContainer extends State<TaskDetailsContainer> {
  double width;
  double height;
  bool editMode;
  List<Widget> listedTasks = [];

  @override
  void initState() {
    super.initState();

    editMode = widget.task == null ? true : widget.editor;
    _addTaskDetails(widget.task);
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
            Column(children: listedTasks),
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

  void _addTaskDetails(Task task, [bool addSubtask = true]) {
    setState(() {
      listedTasks.add(_getTaskDetails(task, addSubtask));
    });
  }

  Widget _getTaskDetails(Task task, [bool addSubtask = true]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(task?.title ?? "Add a task title",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(task?.shortDesc ?? "Add a task short description"),
        Divider(thickness: 1),
        Align(
          alignment: Alignment.topRight,
          child: Text(DateTime.fromMillisecondsSinceEpoch(
                  task?.endDate ?? DateTime.now().millisecondsSinceEpoch)
              .toString()),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: MyContainer(
            radius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.05),
            padding: EdgeInsets.all(10),
            child: Text(task?.desc ?? "Add a description"),
          ),
        ),
        SizedBox(height: addSubtask && editMode && widget.canAddTask ? 0 : 10),
        Visibility(
          visible: addSubtask && editMode && widget.canAddTask,
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
                  onTap: () => _addTaskDetails(null, false),
                  child: Text("ADD A SUBTASK",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )),
                Icon(Icons.add),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
