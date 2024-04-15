import 'package:finziee_dart/services/finziee_shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier{
  late bool? _isDarkMode;
  late bool? _isNotificationAllowed;
  late bool? _isCFAllowed;
  late TimeOfDay? _notificationTime;
  late FinzieeSharedPref _sharedPref;
  bool get isDarkMode => _isDarkMode??false;
  bool get isNotificationAllowed => _isNotificationAllowed??true;
  bool get isCFAllowed => _isCFAllowed??false;
  TimeOfDay get notificationTime => _notificationTime??TimeOfDay(hour: 20, minute: 0);

  SettingsProvider(){
    _isDarkMode = false;
    _isNotificationAllowed = true;
    _isCFAllowed = false;
    _notificationTime = TimeOfDay(hour: 20, minute: 0);
    _sharedPref = FinzieeSharedPref();
    getPreferences();
  }

  set isDark(bool value) {
    _isDarkMode = value;
    _sharedPref.setDarkTheme(value);
    notifyListeners();
  }

  set isNotificationAllowed(bool value) {
    _isNotificationAllowed = value;
    // _sharedPref.setNotificationAllowed(value);
    notifyListeners();
  }

  set isCFAllowed(bool value) {
    _isCFAllowed = value;
    _sharedPref.setCFAllowed(value);
    notifyListeners();
  }

  set notificationTime(TimeOfDay value) {
    _notificationTime = value;
    print('setting notification time to $value');
    // _sharedPref.setNotificationTime(time: value);
    notifyListeners();
  }

  getPreferences() async {
    _isDarkMode = await _sharedPref.getDarkTheme();
    // _isNotificationAllowed = await _sharedPref.getNotificationAllowed();
    _isCFAllowed = await _sharedPref.getCFAllowed();
    // _notificationTime = ValueHelper().getTimeOfDayFromString(await _sharedPref.getNotificationTime());
    notifyListeners();
  }

}