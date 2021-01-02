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
import '../../../tree_handler.dart';
import '../task/task_container.dart';

class TaskTreeContainer extends StatefulWidget {
  final int taskRootId;

  TaskTreeContainer({this.taskRootId});

  @override
  _TaskTreeContainerState createState() => _TaskTreeContainerState();
}

class _TaskTreeContainerState extends State<TaskTreeContainer> {
  TaskDaoImpl taskDao;
  TreeHandler treeHandler;

  Task _currentRootTask;

  @override
  Widget build(BuildContext context) {
    this.taskDao = context.watch<TaskDaoImpl>();
    this.treeHandler = context.watch<TreeHandler>();

    if (this.taskDao == null) return Container();

    _currentRootTask = treeHandler.currentRoot;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskContainer(task: _currentRootTask, isChild: false),
        _buildChildren(_currentRootTask),
      ],
    );
  }

  Widget _buildChildren(Task rootTask) {
    if (rootTask == null) return Container();
    var children = taskDao.findTaskChildren(rootTask.id);
    if (children.isEmpty) {
      return Divider(indent: 50, endIndent: 50, color: Colors.black, thickness: 1);
    }
    return Column(
      children: children.map((child) {
        return TaskContainer(task: child, isChild: true);
      }).toList(),
    );
  }
}
