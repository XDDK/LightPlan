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
import 'package:provider/provider.dart';

import '../../../dao/task_dao_impl.dart';
import '../../../models/task.dart';
import '../../../task_list_handler.dart';
import '../../../tree_handler.dart';
import '../my_container.dart';
import '../tree_timer.dart';
import 'task_tree_container.dart';

class TasksListView extends StatefulWidget {
  final PageController controller;

  TasksListView({@required this.controller});

  @override
  _TasksListViewState createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  TaskDaoImpl taskDao;
  TaskListHandler taskListHandler;

  @override
  Widget build(BuildContext context) {
    taskDao = context.watch<TaskDaoImpl>();
    taskListHandler = context.watch<TaskListHandler>();
    List<Task> treeRoots = [];
    bool nextYearExists = false;

    if (taskDao != null) {
      // Add all the tree roots into the list
      for (var task in taskDao.findAllTasks()) {
        if (task.parentId == null) {
          var rootYear = DateTime.fromMillisecondsSinceEpoch(task.endDate).year;
          if (rootYear == DateTime.now().year + 2) nextYearExists = true;
          treeRoots.add(task);
        }
      }
    }

    return Expanded(
      child: Stack(
        children: [
          PageView.builder(
            controller: widget.controller,
            scrollDirection: Axis.horizontal,
            itemCount: treeRoots.length,
            physics: treeRoots.length > 1 ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return MyContainer(
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(10),
                shadowType: ShadowType.MEDIUM,
                radius: 20,
                child: ChangeNotifierProvider(
                  // Every Tree will have their own TreeTimer and TaskTreeContainer
                  create: (_) => TreeHandler(treeRoots[index]),
                  child: ListView(
                    children: [
                      TreeTimer(),
                      TaskTreeContainer(),
                    ],
                  ),
                ),
              );
            },
          ),
          _buildEndOfYearButton(DateTime.now().month == 12 && !nextYearExists),
        ],
      ),
    );
  }

  Widget _buildEndOfYearButton(bool visible) {
    return Visibility(
      visible: visible,
      child: Positioned.fill(
        right: -15,
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () async {
              await taskDao.insertDefaults(DateTime.now().year + 1);
              setState(() {});
            },
            child: MyContainer(
              color: Colors.deepOrange[100],
              radius: 15,
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
              shadowType: ShadowType.SMALL,
              child: Icon(Icons.add),
              // onTap: () => taskDao.insertDefaults(DateTime.now().year+1),
            ),
          ),
        ),
      ),
    );
  }
}
