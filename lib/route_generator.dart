import 'package:flutter/material.dart';
import 'package:lighthouse_planner/ui/screens/main_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainView());
      /* case '/tasks':
        return MaterialPageRoute(builder: (_) => TasksPage()); */
      /* case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage()); */
      /* case '/terms':
        return MaterialPageRoute(builder: (_) => TermsPage()); */
      default:
        return _notFoundRoute(settings.name);
    }
  }

  static Route<dynamic> _notFoundRoute([String name]) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('404 :('),
        ),
        body: Center(
          child: Text('The page you were searching for doesn\'t exist. $name'),
        ),
      );
    });
  }
}
