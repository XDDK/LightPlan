/*   
*    Lightplan is an open source app created with the intent of helping users keep track of tasks.
*    Copyright (C) 2020  XDDK and ChrisPC-39
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
*    along with this program.  If not, see https://www.gnu.org/licenses/.
*
*    Contact the authors at: contact@lightplanx.com
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dao/task_dao_impl.dart';
import '../../task_list_handler.dart';
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
