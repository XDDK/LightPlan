import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../dao/task_dao_impl.dart';
import '../../models/task.dart';
import '../../tree_handler.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/tree_preview.dart';
import '../widgets/tree_timer.dart';
import 'package:lighthouse_planner/ui/widgets/containers/card_container.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureProvider(
        create: (_) => TaskDaoImpl().init(),
        child: ChangeNotifierProvider(
          create: (_) => TreeHandler(),
          child: Scaffold(
            body: FutureBuilder<Box<Task>>(
              future: Hive.openBox<Task>('tasks'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      TreeTimer(),
                      Expanded(
                        child: CardContainer(
                          child: SingleChildScrollView(
                            child: TreePreview(),
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 300),
                        child: SizedBox()),
                      MyBottomBar(),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
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
