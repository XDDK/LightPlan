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

import 'ui/screens/main_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainPage());
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
