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

library library_th;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'dao/preferences.dart';

ThemeHandler themeHandler = ThemeHandler();

enum _CurrentTheme { SYSTEM, LIGHT, DARK, BLACK }

class ThemeHandler with ChangeNotifier {
  _CurrentTheme _currentTheme;

  ThemeHandler() {
    // _isDarkTheme = Preferences.getInstance().getDarkTheme() ?? false;
  }

  final ThemeData blackMode = ThemeData(
    brightness: Brightness.dark,
    canvasColor: Colors.black,
    cardColor: Colors.grey[900],
    primaryColor: Colors.black,
    accentColor: Colors.black,
    fontFamily: 'WorkSans',
  );

  final ThemeData darkMode = ThemeData(
    primaryColor: Colors.grey[900],
    brightness: Brightness.dark,
    fontFamily: 'WorkSans',
  );

  final ThemeData whiteMode = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    fontFamily: 'WorkSans',
  );

  // SYSTEM=0, LIGHT=1, DARK=2, BLACK=3,
  int get currentThemeIndex {
    return _currentTheme?.index ?? 0;
  }

  Color baseColor([bool opposite = false]) {
    if (_currentTheme == _CurrentTheme.LIGHT ||
        (_currentTheme == _CurrentTheme.SYSTEM &&
            SchedulerBinding.instance.window.platformBrightness == Brightness.light)) {
      return opposite ? Colors.black : Colors.white;
    }
    return opposite ? Colors.white : Colors.black;
  }

  ThemeData get currentTheme {
    switch (_currentTheme) {
      case _CurrentTheme.LIGHT:
        return whiteMode;
      case _CurrentTheme.DARK:
        return darkMode;
      case _CurrentTheme.BLACK:
        return blackMode;
      default:
        return SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? darkMode : whiteMode;
    }
  }

  ThemeMode get currentThemeMode {
    switch (_currentTheme) {
      case _CurrentTheme.LIGHT:
        return ThemeMode.light;
      case _CurrentTheme.DARK:
        return ThemeMode.dark;
      case _CurrentTheme.BLACK:
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  void changeTheme(Preferences prefs, [int themeIndex = 0]) {
    _currentTheme = _CurrentTheme.values[themeIndex];
    prefs.setAppTheme(themeIndex);
    notifyListeners();
  }
}
