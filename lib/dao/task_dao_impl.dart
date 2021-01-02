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
import 'task_dao.dart';

class TaskDaoImpl extends TaskDao {
  final Box<Task> tasksBox = Hive.box("tasks");

  Future<TaskDaoImpl> insertDefaults([int year]) async {
    if(year == null) {
      year = DateTime.now().year;
      if (tasksBox.isNotEmpty) return this;
    }

    print("inserting db defaults for year $year");
    Task yearTask = Task(
        title: "$year",
        endDate: DateTime(year, 12, 31, 24).millisecondsSinceEpoch,
        isPredefined: true,
        canHaveChildren: false,
        shortDesc: "New year new me, right?",
        desc: "Get a car, quit smoking, be healthy. I think you got it!");
    int yearId = await insertTask(yearTask);
    Task quarter1 = Task(
        title: "January - March",
        parentId: yearId,
        endDate: DateTime(year, 3, 31, 24).millisecondsSinceEpoch,
        isPredefined: true,
        shortDesc: "Stuff we do in spring",
        desc: "blah blah");
    Task quarter2 = Task(
        title: "April - June",
        parentId: yearId,
        endDate: DateTime(year, 6, 30, 24).millisecondsSinceEpoch,
        isPredefined: true,
        shortDesc: "Stuff we do in summer",
        desc: "blah blah");
    Task quarter3 = Task(
        title: "July - September",
        parentId: yearId,
        endDate: DateTime(year, 9, 30, 24).millisecondsSinceEpoch,
        isPredefined: true,
        shortDesc: "Stuff we do in autumn",
        desc: "blah blah");
    Task quarter4 = Task(
        title: "Octomber - December",
        parentId: yearId,
        endDate: DateTime(year, 12, 31, 24).millisecondsSinceEpoch,
        isPredefined: true,
        shortDesc: "Stuff we do in winter",
        desc: "blah blah");

    await insertTask(quarter1);
    await insertTask(quarter2);
    await insertTask(quarter3);
    await insertTask(quarter4);

    print("end db insertion of defaults");
    return this;
  }

  @override
  Future<void> deleteTask(Task treeTask) {
    if (treeTask == null) return null;
    for (int i = 0; i < tasksBox.length; i++) {
      Task taskAt = tasksBox.getAt(i);
      if (taskAt.parentId == treeTask.id) tasksBox.delete(taskAt.id);
    }
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
    List<Task> tasksList = [];
    for (int i = 0; i < tasksBox.length; i++) {
      tasksList.add(tasksBox.getAt(i));
    }
    return tasksList;
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
