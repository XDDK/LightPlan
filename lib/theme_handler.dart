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

import 'dao/preferences.dart';

ThemeHandler themeHandler = ThemeHandler();

class ThemeHandler with ChangeNotifier {
  static bool _isDarkTheme = false;

  ThemeHandler() {
    _isDarkTheme = Preferences.getInstance().getDarkTheme() ?? false;
  }

  final ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'WorkSans',
  );

  final ThemeData whiteMode = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'WorkSans',
  );

  bool get isDarkTheme {
    return _isDarkTheme;
  }

  ThemeData get currentTheme {
    return _isDarkTheme ? darkMode : whiteMode;
  }

  void switchTheme() {
    _isDarkTheme = !_isDarkTheme;
    Preferences.getInstance().setDarkTheme(_isDarkTheme);
    notifyListeners();
  }
}