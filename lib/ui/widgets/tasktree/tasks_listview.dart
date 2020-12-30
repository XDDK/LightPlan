import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dao/task_dao_impl.dart';
import '../../../models/task.dart';
import '../../../tree_handler.dart';
import '../tree_timer.dart';
import 'task_tree_container.dart';

class TasksListView extends StatelessWidget {
  final PageController controller = PageController(initialPage: 1, viewportFraction: 0.75);

  @override
  Widget build(BuildContext context) {
    var taskDao = context.watch<TaskDaoImpl>();
    List<Task> treeRoots = []; // TODO get tree roots inside db

    if (taskDao != null) {
      for (var task in taskDao.findAllTasks()) {
        if (task.parentId == null) treeRoots.add(task);
      }
    }

    return Expanded(
      child: PageView.builder(
        controller: this.controller,
        scrollDirection: Axis.horizontal,
        itemCount: treeRoots.length,
        physics: treeRoots.length > 1 ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //! TODO provider of TreeHandler over every TreeTask
          return Container(
              child: ChangeNotifierProvider(
                // Every Tree will have their own TreeTimer and TaskTreeContainer
                create: (_) => TreeHandler(treeRoots[index]),
                child: Column(
                  children: [
                    TreeTimer(),
                    TaskTreeContainer(),
                  ],
                ),
              ),
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(100, 0, 0, 0),
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            );
        },
      ),
    );
  }
}
