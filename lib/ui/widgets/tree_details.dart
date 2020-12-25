import 'package:flutter/material.dart';
import 'package:lighthouse_planner/models/task.dart';

class TreeDetails extends StatefulWidget {
  final Task currentTree;

  TreeDetails({@required this.currentTree});

  @override
  _TreeDetailsState createState() => _TreeDetailsState();
}

class _TreeDetailsState extends State<TreeDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(this.widget.currentTree.desc)),
    );
  }
}