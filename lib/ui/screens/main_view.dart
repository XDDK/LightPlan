import 'package:flutter/material.dart';
import 'package:lighthouse_planner/models/tree_task.dart';
import 'package:lighthouse_planner/ui/widgets/tree_preview.dart';
import 'package:lighthouse_planner/ui/widgets/tree_timer.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  TreeTask currentTree;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TreeTimer(),
            TreePreview(treeTask: currentTree),
          ],
        ),
      ),
    );
  }
}
