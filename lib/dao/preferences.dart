//#region License Information (GPL v3)

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

//#region License Information (GPL v3)

import 'package:hive/hive.dart';

class Preferences {
  static Box<dynamic> _box;
  static const _preferencesBox = 'preferencesBox';

  static const _lastViewedYearKey = 'lastViewedYearKey';
  static const _lastViewedTaskKey = 'lastViewedTaskKey';
  static const _tutorial = 'tutorialKey';
  static const _darkTheme = 'darkThemeKey';

  Preferences._(Box<dynamic> box) {
    _box = box;
  }

  static Future<Preferences> getFutureInstance() async {
    final box = await Hive.openBox<dynamic>(_preferencesBox);
    return Preferences._(box);
  }

  static Preferences getInstance() {
    return Preferences._(Hive.box(_preferencesBox));
  }

  int getLastViewedYear() {
    return _box.get(_lastViewedYearKey);
  }

  Future<void> setLastViewedYear(int lastYear) {
    return _box.put(_lastViewedYearKey, lastYear);
  }

  int getLastViewedTask() {
    return _box.get(_lastViewedTaskKey);
  }

  Future<void> setLastViewedTask(int lastTask) {
    return _box.put(_lastViewedTaskKey, lastTask);
  }

  bool getDarkTheme() {
    return _box.get(_darkTheme, defaultValue: false);
  }

  Future<void> setDarkTheme(bool darkTheme) {
    return _box.put(_darkTheme, darkTheme);
  }

  bool showTutorial() {
    return _box.get(_tutorial, defaultValue: true);
  }

  Future<void> setShowTutorial(bool showTutorial) {
    return _box.put(_tutorial, showTutorial);
  }
}