import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lighthouse_planner/ui/screens/settings_page.dart';

import 'models/task.dart';
import 'route_generator.dart';
import 'ui/screens/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init hive boxes
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lightplan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "WorkSans"
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => MainPage(),
        // '/tasks': (_) => TasksPage(),
        '/settings': (_) => SettingsPage(),
        // '/terms': (_) => TermsPage(),
      },
      onUnknownRoute: RouteGenerator.generateRoute,
      //* GenerateRoute is currently bugged and doesn't have browser history and doesn't pass route names to url
      // onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
