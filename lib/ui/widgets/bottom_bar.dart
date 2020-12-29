import 'package:flutter/material.dart';
import 'package:lighthouse_planner/ui/widgets/containers/my_container.dart';
import 'package:lighthouse_planner/dao/task_dao_impl.dart';
import '../../tree_handler.dart';
import 'package:provider/provider.dart';

class MyBottomBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyBottomBar();
  }
}

class _MyBottomBar extends State<MyBottomBar> {
  TaskDaoImpl taskDao;
  TreeHandler treeHandler;

  @override
  Widget build(BuildContext context) {
    this.taskDao = context.watch<TaskDaoImpl>();
    this.treeHandler = context.watch<TreeHandler>();

    if (this.taskDao == null) return Container();
    if (treeHandler.currentTask == null) treeHandler.setCurrentTask(taskDao.findTaskAt(0), false);

    return Center(
      heightFactor: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //BottomBar UI: Home button
          MyContainer(
            ripple: true,
            color: Colors.transparent,
            child: Icon(Icons.home, size: 50),
            padding: EdgeInsets.all(10),
            onTap: () {
              treeHandler.setCurrentTask(taskDao.findTaskAt(0));
            },
          ),

          //BottomBar UI: Divider
          SizedBox(
            height: 40,
            child: VerticalDivider(
              thickness: 1,
              indent: 5,
              endIndent: 5,
            ),
          ),
          
          //BottomBar UI: Settings menu
          MyContainer(
            ripple: true,
            color: Colors.transparent,
            child: Icon(Icons.settings, size: 50),
            padding: EdgeInsets.all(10),
            onTap: () {
              print("Settings");
            },
          ),
        ],
      ),
    );
  }
}