import 'package:lighthouse_planner/models/task.dart';

abstract class TaskDao {
  List<Task> findAllTasks();

  Task findTask(int id);

  Task findTaskAt(int pos);

  List<Task> findTaskChildren(int id);

  Future<int> insertTask(Task treeTask);

  Future<void> deleteTask(Task treeTask);

  Future<void> deleteTasks(List<Task> treeTask);

  Future<void> updateTask(int id, Task task);
}
