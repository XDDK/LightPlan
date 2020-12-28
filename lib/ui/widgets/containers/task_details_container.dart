import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  bool isPressedGreen = false;
  bool isPressedRed = false;
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
            //Preview UI: show current task details
            Column(children: listedTasks),

            //Preview UI: save and delete buttons
            Visibility(
              visible: editMode,
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    //Delete button
                    Expanded(
                      child: GestureDetector(
                        onTapCancel: () {
                          if(!kIsWeb)
                            setState(() {isPressedRed = false;});
                        },
                        onTapDown: (e) {
                          if(!kIsWeb)
                            setState(() {isPressedRed = true;});
                        },
                        onTapUp: (e) {
                          if(!kIsWeb)
                            setState(() {isPressedRed = false;});
                        },
                        child: MyContainer(
                          isHoverable: true,
                          height: 30,
                          child: Icon(Icons.delete),
                          color: isPressedRed ? Colors.redAccent : Colors.red,
                          //color: Colors.red,
                          radius: 5,
                        ),
                      ),
                    ),

                    //Empty container used for formatting
                    SizedBox(width: 10),

                    //Save button
                    Expanded(
                      child : GestureDetector(
                        onTapCancel: () {
                          if(!kIsWeb)
                            setState(() {isPressedGreen = false;});
                        },
                        onTapDown: (e) {
                          if(!kIsWeb)
                            setState(() {isPressedGreen = true;});
                        },
                        onTapUp: (e) {
                          if(!kIsWeb)
                            setState(() {isPressedGreen = false;});
                        },
                        child: MyContainer(
                          isHoverable: true,
                          height: 30,
                          child: Icon(Icons.save),
                          color: isPressedGreen ? Colors.green[200] : Colors.green,
                          radius: 5,
                        ),
                      ),
                    ),
                  ],
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
        //Preview UI: Title and ShortDescription
        Text(task?.title ?? "Add a task title", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(task?.shortDesc ?? "Add a task short description"),
        Divider(thickness: 1),

        //Preview UI: Time
        Align(
          alignment: Alignment.topRight,
          child: Text(DateTime.fromMillisecondsSinceEpoch(
                  task?.endDate ?? DateTime.now().millisecondsSinceEpoch)
              .toString()),
        ),

        //Empty container used for formatting
        SizedBox(height: 10),

        //Preview UI: Description
        SizedBox(
          width: double.infinity,
          child: MyContainer(
            radius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.05),
            padding: EdgeInsets.all(10),
            child: Text(task?.desc ?? "Add a description"),
          ),
        ),

        //Empty container used for formatting
        SizedBox(height: addSubtask && editMode && widget.canAddTask ? 0 : 10),

        //Preview UI: "Add task" bar
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
                    child: Text("ADD A SUBTASK", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),

                Icon(Icons.add),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
