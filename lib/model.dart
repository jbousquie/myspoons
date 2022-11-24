// https://www.freecodecamp.org/news/provider-pattern-in-flutter/

// https://davidserrano.io/best-way-to-handle-permissions-in-your-flutter-app

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';
import 'notification_service.dart';

class SpoonTracker extends ChangeNotifier {
  int _energyRate = 100;
  late int _spoonNb = _computeSpoonNb(_energyRate);
  String _comment = '';
  late String _dateString = stringDateNow();
  final String _path = '/storage/emulated/0/Download';
  final String _columns = 'Timestamp;WeekDay;EnergyRate;SpoonNb;Comment\n';
  final String _filename = 'myspoons.csv';
  late Settings settings;
  SpoonTracker() {
    setbackInitials();
  }

  int get energyRate {
    return _energyRate;
  }

  int get spoonNb {
    return _spoonNb;
  }

  String get comment {
    return _comment;
  }

  String get dateString {
    return _dateString;
  }

  set dateString(value) {
    _dateString = value;
  }

  set comment(value) {
    _comment = value;
    notifyListeners();
  }

  void updateEnergyRate(int value) {
    _energyRate = value;
    _spoonNb = _computeSpoonNb(value);
    notifyListeners();
  }

  int _computeSpoonNb(value) {
    return (value * settings.maxSpoonNb / 100).round();
  }

  String stringDateNow() {
    final String stdn = DateTime.now().toString().substring(0, 19);
    return stdn;
  }

  int weekDay() {
    final int wd = DateTime.now().weekday;
    return wd;
  }

  void linkSettings(Settings params) {
    settings = params;
    settings.spoonTracker = this;
  }

  Future<File> get _localFile async {
    //final path = await _localPath;
    final String filePath = '$_path/$_filename';
    final File f = File(filePath);
    return f;
  }

  Future<File> _writeData(String dateString, int weekday, int energyRate, int spoonNb, String comment) async {
    final file = await _localFile;
    final bool hasFilePersmission = await requestFilePermission();
    if (hasFilePersmission) {
      if (!await file.exists()) {
        file.writeAsStringSync(_columns);
      }
      final row = '$dateString;$weekday;$energyRate;$spoonNb;$comment\n';
      file.writeAsString(row, mode: FileMode.append);
    }
    return file;
  }

  Future<void> setbackInitials() async {
    final prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    _dateString = prefs.getString('date') ?? stringDateNow();
    _energyRate = prefs.getInt('energyrate') ?? 100;
    _comment = prefs.getString('comment') ?? '';
    _spoonNb = prefs.getInt('spoonNb') ?? settings.maxSpoonNb;
    notifyListeners();
  }

  Future<void> logData() async {
    _dateString = stringDateNow();
    final int weekday = weekDay();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('date', _dateString);
    await prefs.setInt('energyrate', _energyRate);
    await prefs.setInt('spoonNb', _spoonNb);
    await prefs.setString('comment', _comment);
    await _writeData(_dateString, weekday, _energyRate, _spoonNb, _comment);
  }

  Future requestFilePermission() async {
    PermissionStatus result;
    if (Platform.isAndroid) {
      result = await Permission.storage.request();
    } else {
      result = await Permission.photos.request();
    }

    if (result.isGranted) {
      return true;
    } else if (result.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }
}

class Settings extends ChangeNotifier {
  int maxSpoonNb = 10;
  bool enableReminder = false;
  int reminderPeriod = 1;
  static int defaultHourStart = 9;
  static int defaultHourStop = 20;
  int hourStart = defaultHourStart;
  int minuteStart = 0;
  int hourStop = defaultHourStop;
  int minuteStop = 0;
  TimeOfDay reminderStart = TimeOfDay(hour: defaultHourStart, minute: 0);
  TimeOfDay reminderStop = TimeOfDay(hour: defaultHourStop, minute: 0);
  late SpoonTracker spoonTracker;
  late final LocalNotificationService localNotificationService;
  Settings() {
    localNotificationService = LocalNotificationService();
    localNotificationService.initialize();
    setbackInitials();
  }

  Future<void> setbackInitials() async {
    final prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    maxSpoonNb = prefs.getInt('maxspoonNb') ?? maxSpoonNb;
    enableReminder = prefs.getBool('enablereminder') ?? enableReminder;
    reminderPeriod = prefs.getInt('reminderperiod') ?? reminderPeriod;
    hourStart = prefs.getInt('reminderhourstart') ?? hourStart;
    minuteStart = prefs.getInt('reminderminutestart') ?? minuteStart;
    hourStop = prefs.getInt('reminderhourstop') ?? hourStop;
    minuteStop = prefs.getInt('reminderminutestop') ?? minuteStop;
    reminderStart = TimeOfDay(hour: hourStart, minute: minuteStart);
    reminderStop = TimeOfDay(hour: hourStop, minute: minuteStop);
    notifyListeners();
  }

  void updateMaxSpoonNb(int value) {
    String oldComment = spoonTracker.comment;
    spoonTracker._comment = 'Change max spoon number from $maxSpoonNb to $value';
    spoonTracker.logData();
    spoonTracker._comment = oldComment;
    maxSpoonNb = value;
    storeSettings();
    notifyListeners();
  }

  void updateReminder(bool enabled, int period, TimeOfDay notifierStart, TimeOfDay notifierStop) {
    localNotificationService.plugin.cancelAll();
    enableReminder = enabled;
    reminderPeriod = period;
    reminderStart = notifierStart;
    reminderStop = notifierStop;
    storeSettings();
    notifyListeners();
  }

  Future<void> storeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxspoonNb', maxSpoonNb);
    await prefs.setBool('enableReminder', enableReminder);
    await prefs.setInt('reminderperiod', reminderPeriod);
    hourStart = reminderStart.hour;
    minuteStart = reminderStart.minute;
    hourStop = reminderStop.hour;
    minuteStop = reminderStop.minute;
    await prefs.setInt('reminderhourstart', hourStart);
    await prefs.setInt('reminderminutestart', minuteStart);
    await prefs.setInt('reminderjourstop', hourStop);
    await prefs.setInt('reminderminutestop', minuteStop);
  }
}
