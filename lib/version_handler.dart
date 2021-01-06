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