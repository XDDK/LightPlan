import 'package:flutter/material.dart';
import 'package:lighthouse_planner/task_list_handler.dart';
import 'package:provider/provider.dart';

import '../../dao/task_dao_impl.dart';
import 'my_container.dart';

class MyBottomBar extends StatefulWidget {
  final PageController treeController;

  MyBottomBar({@required this.treeController});

  @override
  State<StatefulWidget> createState() {
    return _MyBottomBar();
  }
}

class _MyBottomBar extends State<MyBottomBar> {
  TaskDaoImpl taskDao;
  TaskListHandler taskListHandler;

  @override
  Widget build(BuildContext context) {
    this.taskDao = context.watch<TaskDaoImpl>();
    this.taskListHandler = context.watch<TaskListHandler>();
    if (this.taskDao == null) return Container();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //BottomBar UI: Left arrow
        /*
        Visibility(
          visible: widget.treeController.page < taskListHandler.taskRootCount,
          child: MyContainer(
            ripple: true,
            color: Colors.transparent,
            width: 50,
            height: 50,
            child: FittedBox(child: Icon(Icons.arrow_back_ios)),
            padding: EdgeInsets.all(10),
            onTap: () {
              if (widget.treeController.page > 0) {
                widget.treeController.previousPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
              }
            },
          ),
        ),
        //BottomBar UI: Divider
        SizedBox(
          height: 40,
          child: VerticalDivider(
            thickness: 1,
            indent: 5,
            endIndent: 5,
          ),
        ),
        */
        //BottomBar UI: Settings menu
        MyContainer(
          ripple: true,
          color: Colors.transparent,
          child: Icon(Icons.settings, size: 50),
          padding: EdgeInsets.all(10),
          onTap: () {
            Navigator.of(context).pushNamed("/settings");
          },
        ),
        /*
        //BottomBar UI: Divider
        SizedBox(
          height: 40,
          child: VerticalDivider(
            thickness: 1,
            indent: 5,
            endIndent: 5,
          ),
        ),
        //BottomBar UI: Right arrow
        Visibility(
          // visible: taskListHandler.currentPage != null && taskListHandler.currentPage < taskListHandler.tasksCount,
          child: MyContainer(
            ripple: true,
            color: Colors.transparent,
            width: 50,
            height: 50,
            child: FittedBox(child: Icon(Icons.arrow_forward_ios)),
            padding: EdgeInsets.all(10),
            onTap: () {
              widget.treeController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.linear,
              );
            },
          ),
        ),*/
      ],
    );
  }
}
