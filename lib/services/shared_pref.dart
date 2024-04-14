import 'package:finziee_dart/services/notification_service.dart';
import 'package:finziee_dart/util/value_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SharedPref{
  //Theme related
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  //Notification related
  final _notificationKey = 'isNotificationsAllowed';
  final _notificationTime = 'notificationTime';
  final ValueHelper valueHelper = ValueHelper();

  //cf related
  final String isCFallowedKey = "CFAllowed";

  //cf related methods
  bool _loadCFAllowedFlag() => _storage.read(isCFallowedKey)??false;
  
  toggleCFAllowedFlag() {
    bool isCFAllowed = _loadCFAllowedFlag();
    _storage.write(isCFallowedKey, !isCFAllowed);
    print("CF Allowed: $isCFAllowed");
  }
  bool get cfAllowed => _loadCFAllowedFlag();
  
  

  //Notification related methods
  _saveNotificationSettingsToStorage(bool isNotificationsAllowed, {TimeOfDay time = const TimeOfDay(hour: 20, minute: 0)}) {
    _storage.write(_key, isNotificationsAllowed);
    _storage.write(_notificationTime, valueHelper.getFormattedTimeIn12Hr(time));
  }
  
  bool _loadNotificationAllowedFromStorage() => _storage.read(_key)??false;

  TimeOfDay _loadNotificationTimeFromStorage()=> valueHelper.getTimeOfDayFromString(_storage.read(_notificationTime)??"8:00 PM");
  
  bool get notificationAllowed => _loadNotificationAllowedFromStorage();
  TimeOfDay get notificationTime => _loadNotificationTimeFromStorage();


  //Theme related methods
  _saveThemeToStorage(bool isDarkMode)=>_storage.write(_key, isDarkMode);
  
  bool _loadThemeFromStorage()=>_storage.read(_key)??false;
  ThemeMode get theme => _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;
  
  void switchTheme(){
    bool isDarkMode = _loadThemeFromStorage();
    print('theme: $isDarkMode');
    Get.changeThemeMode(_loadThemeFromStorage()?ThemeMode.light:ThemeMode.dark);
    _saveThemeToStorage(!_loadThemeFromStorage());
  }

  void turnOffNotifications(bool isNotificationAllowed) async {
    print('notification turned off with bool val: $isNotificationAllowed');
    await NotificationService().cancelDailyNotification();
    _saveNotificationSettingsToStorage(isNotificationAllowed);
  }

  void turnOnNotifications(bool isNotificationAllowed, TimeOfDay chosenTime) async {
    print('notification turned on with bool val: $isNotificationAllowed');
    await NotificationService().scheduleDailyNotification(chosenTime);
    _saveNotificationSettingsToStorage(isNotificationAllowed, time: chosenTime);
  }
}