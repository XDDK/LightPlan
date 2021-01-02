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