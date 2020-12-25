import 'package:hive/hive.dart';
import 'package:lighthouse_planner/dao/task_dao.dart';
import 'package:lighthouse_planner/models/task.dart';

class TaskDaoImpl extends TaskDao {
  final Box<Task> tasksBox = Hive.box("tasks");

  TaskDaoImpl() {
    if(tasksBox.isEmpty) {
      init(tasksBox);
    }
  }

  void init(Box<Task> box) {
    print("db init");
    Task year = Task(
        title: "2k2k",
        parentId: 0,
        shortDesc: "This year was fun",
        desc: "this year was not fun...");
    box.add(year);
    print("end db init");
  }

  @override
  Future<void> deleteTask(Task treeTask) {
    return tasksBox.delete(treeTask);
  }

  @override
  Future<void> deleteTasks(List<Task> treeTask) {
    return tasksBox.deleteAll(treeTask);
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
    print("finding task #$id");
    return tasksBox.get(id);
  }

  @override
  List<Task> findTaskChildren(int id) {
    return tasksBox.values.where((e) {
      return e.parentId == id;
    }).toList();
  }

  @override
  Future<int> insertTask(Task treeTask) {
    return tasksBox.add(treeTask);
  }
}
