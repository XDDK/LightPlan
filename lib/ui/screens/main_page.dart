import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../dao/task_dao_impl.dart';
import '../../models/task.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/tasktree/tasks_listview.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TaskDaoImpl taskDaoImpl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Box<Task>>(
          future: Hive.openBox<Task>('tasks'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              taskDaoImpl = TaskDaoImpl();
              var viewPort = MediaQuery.of(context).size.width > 950 ? 0.3 : 0.75;
              return FutureProvider(
                create: (_) => taskDaoImpl.insertDefaults(),
                child: Column(
                  children: [
                    TasksListView(viewPort: viewPort),
                    MyBottomBar(),
                  ],
                ),
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

   Future<bool> _showConfirmQuit() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Are you sure you want to quit?'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
