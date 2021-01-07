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

import 'package:hive/hive.dart';

import '../models/task.dart';
import '../utils.dart';
import 'task_dao.dart';

class TaskDaoImpl extends TaskDao {
  static TaskDaoImpl instance;
  final Box<Task> tasksBox = Hive.box("tasks");

  static TaskDaoImpl getInstance() {
    if (instance == null) instance = TaskDaoImpl();
    return instance;
  }

  Future<void> updateDefaults(int oldVer, int newVer) async {
    if (tasksBox.isEmpty) return;
    print("updating current predefined tasks");
    print("old tasks: ${findAllTasks()}\n\n");
    // Update the existing predefined tasks (root + first children)
    List<Task> parentTasks = findAllTasks().where((task) => task.parentId == null).toList();
    parentTasks.forEach((element) async {
      await updateTask(element.id, element.copyWith(recurrence: Recurrence.NONE));
      List<Task> deepChildren = [];
      findDeepChildren(element, deepChildren);
      deepChildren.forEach((element) async {
        await updateTask(element.id, element.copyWith(recurrence: Recurrence.NONE));
      });
    });
    
    parentTasks.forEach((parentTask) async {
      List<Task> defaultTasks = Utils.getTaskDefaults(parentTask.getEndDateTime().year - 1);
      List<Task> children = findTaskChildren(parentTask.id);
      Task q1Task = children[0], q2Task = children[1], q3Task = children[2], q4Task = children[3];

      await updateTask(parentTask.id, parentTask.copyWith(startDate: defaultTasks[0].startDate));
      await updateTask(q1Task.id, q1Task.copyWith(startDate: defaultTasks[1].startDate));
      await updateTask(q2Task.id, q2Task.copyWith(startDate: defaultTasks[2].startDate));
      await updateTask(q3Task.id, q3Task.copyWith(startDate: defaultTasks[3].startDate));
      await updateTask(q4Task.id, q4Task.copyWith(startDate: defaultTasks[4].startDate));
    });
    print("updated tasks: ${findAllTasks()}\n\n");
  }

  Future<TaskDaoImpl> insertDefaults([int year]) async {
    if (year == null) {
      year = DateTime.now().year;
      if (tasksBox.isNotEmpty) return this;
    }

    print("inserting db defaults for year $year");
    // Insert default Tasks in Hive Box ('tasks')
    List<Task> defaults = Utils.getTaskDefaults(year);
    int yearId = await insertTask(defaults[0]);
    await insertTask(defaults[1].copyWith(parentId: yearId));
    await insertTask(defaults[2].copyWith(parentId: yearId));
    await insertTask(defaults[3].copyWith(parentId: yearId));
    await insertTask(defaults[4].copyWith(parentId: yearId));

    print("end db insertion of defaults");
    return this;
  }

  @override
  Future<void> deleteTask(Task treeTask) async {
    // Delete the task + all his direct and indirect children
    if (treeTask == null) return null;
    List<Task> toDeleteChildren = [];
    findDeepChildren(treeTask, toDeleteChildren);
    toDeleteChildren.forEach((element) => tasksBox.delete(element.id));
    return tasksBox.delete(treeTask.id);
  }

  @override
  Future<void> deleteTasks(List<Task> treeTask) async {
    treeTask.forEach((element) async {
      await deleteTask(element);
    });
  }

  @override
  List<Task> findAllTasks() {
    return tasksBox.values.toList();
  }

  void findDeepChildren(Task parentTask, List<Task> deepChildren) {
    for (var child in findTaskChildren(parentTask.id)) {
      findDeepChildren(child, deepChildren);
      deepChildren.add(child);
    }
  }

  @override
  Task findTask(int id) {
    return tasksBox.get(id);
  }

  @override
  Task findTaskAt(int pos) {
    return tasksBox.getAt(pos);
  }

  @override
  List<Task> findTaskChildren(int id) {
    return tasksBox.values.where((e) {
      return e.parentId == id;
    }).toList();
  }

  @override
  Future<int> insertTask(Task treeTask) async {
    int idTask = await tasksBox.add(treeTask);
    updateTask(idTask, treeTask.setId(idTask));
    return idTask;
  }

  @override
  Future<void> updateTask(int id, Task treeTask) async {
    return await tasksBox.put(id, treeTask);
  }

  @override
  Future<int> insertOrUpdate(Task treeTask) async {
    if (treeTask.id != null) {
      updateTask(treeTask.id, treeTask);
      return treeTask.id;
    }
    return insertTask(treeTask);
  }
}
