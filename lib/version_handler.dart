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

//#endregion License Information (GPL v3)

import 'dao/preferences.dart';

class VersionHandler {
  /// Change when updating the Task model adapter
  static const int _currentTaskVersion = 2;

  /// @int oldVer, @int newVer
  void Function(int, int) _onUpgrade;

  VersionHandler(Preferences prefs, this._onUpgrade) {
    int lastVer = prefs.getLastTaskVersion();
    if(lastVer < _currentTaskVersion) {
      // Perform onUpgrade callback
      this._onUpgrade(lastVer, _currentTaskVersion);
      // Set the newVersion in the preferences
      prefs.setLastTaskVersion(_currentTaskVersion);
    }
  }
}