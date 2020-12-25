import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lighthouse_planner/dao/task_dao_impl.dart';
import 'package:lighthouse_planner/database/db_handler.dart';
import 'package:lighthouse_planner/models/task.dart';
import 'package:lighthouse_planner/ui/widgets/tree_preview.dart';
import 'package:lighthouse_planner/ui/widgets/tree_timer.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    // this.currentTask = new Task();

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: Hive.openBox<Task>('tasks'),
          builder: (context, AsyncSnapshot<Box<Task>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  TreeTimer(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DbHandler(
                        taskDao: TaskDaoImpl(),
                        child: TreePreview(),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
