import 'package:lighthouse_planner/models/task.dart';

// @dao
abstract class TaskDao {
  // @Query("SELECT * FROM TreeTask")
  List<Task> findAllTasks();

  // @Query("SELECT * FROM TreeTask WHERE id = :id")
  Task findTask(int id);

  // @Query("SELECT * FROM TreeTask WHERE parent_id = :id")
  List<Task> findTaskChildren(int id);

  // @insert
  Future<int> insertTask(Task treeTask);

  // @delete
  Future<void> deleteTask(Task treeTask);

  // @delete
  Future<void> deleteTasks(List<Task> treeTask);
}
