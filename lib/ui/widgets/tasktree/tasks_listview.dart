import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dao/task_dao_impl.dart';
import '../../../models/task.dart';
import '../../../tree_handler.dart';
import '../my_container.dart';
import '../tree_timer.dart';
import 'task_tree_container.dart';

class TasksListView extends StatefulWidget {
  final double viewPort;

  TasksListView({this.viewPort});

  @override
  _TasksListViewState createState() => _TasksListViewState();
}

class _TasksListViewState extends State<TasksListView> {
  TaskDaoImpl taskDao;

  @override
  Widget build(BuildContext context) {
    taskDao = context.watch<TaskDaoImpl>();
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
      // treeRoots = treeRoots.reversed.toList();
    }

    return Expanded(
      child: Stack(
        children: [
          PageView.builder(
            controller: PageController(initialPage: treeRoots.length-1, viewportFraction: widget.viewPort),
            scrollDirection: Axis.horizontal,
            itemCount: treeRoots.length,
            physics: treeRoots.length > 1 ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return MyContainer(
                color: Colors.white,
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
              setState(() { });
            },
            child: MyContainer(
              color: Colors.deepOrange[100],
              radius: 15,
              height: double.infinity,
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
