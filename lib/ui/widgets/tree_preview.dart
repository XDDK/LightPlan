import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:lighthouse_planner/models/tree_task.dart';

class TreePreview extends StatelessWidget {
  final TreeTask treeTask;

  TreePreview({this.treeTask});

  @override
  Widget build(BuildContext context) {
    if(this.treeTask == null) return Text("Tree is null");
    return Column(children: [
      buildSelf(this.treeTask),
      buildChildren(this.treeTask),
    ]);
  }

  Widget buildSelf(TreeTask tree) {
    return Placeholder();
  }

  Widget buildChildren(TreeTask tree) {
    if(tree.children.isEmpty)
      return Placeholder();
    return Column(children: tree.children.map((child)  {
      return buildSelf(child);
    }).toList());
  }
}
