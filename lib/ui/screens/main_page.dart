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

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lightplan/theme_handler.dart';
import 'package:lightplan/ui/screens/tutorial_widget.dart';
import 'package:provider/provider.dart';

import '../../dao/preferences.dart';
import '../../dao/task_dao_impl.dart';
import '../../models/task.dart';
import '../../task_list_handler.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/tasktree/tasks_listview.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TaskDaoImpl taskDaoImpl;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      themeHandler.switchTheme(await Preferences.getFutureInstance(), Preferences.getInstance().getDarkTheme());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _showConfirmQuit(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: AnimatedSwitcher(
            child: FutureBuilder<Preferences>(
                future: Preferences.getFutureInstance(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) return Container();
                  return Preferences.getInstance().showTutorial() ? TutorialWidget() : _buildTasksPage;
                }),
            duration: Duration(seconds: 3),
          ),
        ),
      ),
    );
  }

  Widget get _buildTasksPage {
    var controller = PageController(
      initialPage: 0,
      viewportFraction: MediaQuery.of(context).size.width > 950 ? 0.3 : 1.0,
    );
    return FutureBuilder<Box<Task>>(
      future: Hive.openBox<Task>('tasks'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FutureProvider(
            create: (_) => TaskDaoImpl().insertDefaults(),
            child: ChangeNotifierProvider(
              create: (context) => TaskListHandler(),
              child: Column(
                children: [
                  TasksListView(
                    controller: controller,
                    searchedTask: {
                      Preferences.getInstance().getLastViewedYear(): Preferences.getInstance().getLastViewedTask(),
                    },
                  ),
                  MyBottomBar(treeController: controller),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
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
