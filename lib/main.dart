import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lighthouse_planner/models/task.dart';
import 'package:lighthouse_planner/ui/screens/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init hive boxes
  Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lightplan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainView(),
      );
  }
}
