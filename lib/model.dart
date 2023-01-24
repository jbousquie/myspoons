// https://www.freecodecamp.org/news/provider-pattern-in-flutter/

// https://davidserrano.io/best-way-to-handle-permissions-in-your-flutter-app

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'notification_service.dart';
import 'intl.dart';

class SpoonTracker extends ChangeNotifier {
  static int maxEnergyRate = 100;
  int _energyRate = maxEnergyRate;
  late int _spoonNb = _computeSpoonNb(_energyRate);
  String _comment = '';
  String _exportReport = '';
  String _uuid = '';
  late String _dateString = stringDateNow();
  final String _filename = 'myspoons.csv';
  final String collectURL = 'https://jerome.bousquie.fr/myspoons/collect/';
  final String _columns =
      'Timestamp;WeekDay;EnergyRate;SpoonNb;maxSpoonNb;Comment\n';
  final Settings settings = Settings();
  DateTime now = DateTime.now();
  late int dayLastSession = now.day;
  late int monthLastSession = now.month;

  SpoonTracker() {
    setbackInitials();
    settings.spoonTracker = this;
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

  get exportReport {
    return _exportReport;
  }

  set exportReport(value) {
    _exportReport = value;
    notifyListeners();
  }

  Future<String> get uuid async {
    final prefs = await SharedPreferences.getInstance();
    _uuid = prefs.getString('uuid') ?? await generateUuid();
    return _uuid;
  }

  Future<String> generateUuid() async {
    final prefs = await SharedPreferences.getInstance();
    final String uuid = UniqueKey().toString();
    prefs.setString('uuid', uuid);
    return uuid;
  }

  Future<String> get _path async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get filePath async {
    String pth = await _path;
    return '$pth/$_filename';
  }

  void updateEnergyRate(int value) {
    _energyRate = value;
    _spoonNb = _computeSpoonNb(value);
    notifyListeners();
  }

  int _computeSpoonNb(value) {
    return (value * settings.maxSpoonNb / maxEnergyRate).round();
  }

  String stringDateNow() {
    final String stdn = DateTime.now().toString().substring(0, 19);
    return stdn;
  }

  int weekDay() {
    final int wd = DateTime.now().weekday;
    return wd;
  }

  String cleanComment(String comment) {
    String cleaned =
        comment.replaceAll(";", ",").replaceAll("'", " ").replaceAll('"', ' ');
    return cleaned;
  }

  Future<File> get localFile async {
    final fp = await filePath;
    final File f = File(fp);
    return f;
  }

  Future<void> deleteFile() async {
    final file = await localFile;
    if (await file.exists()) {
      file.delete();
    }
  }

  Future<File> _writeData(String dateString, int weekday, int energyRate,
      int spoonNb, int maxSpoonNb, String comment) async {
    final file = await localFile;
    if (!await file.exists()) {
      file.writeAsStringSync(_columns);
    }
    final String cleaned = cleanComment(comment);
    final row =
        '$dateString;$weekday;$energyRate;$spoonNb;$maxSpoonNb;$cleaned\n';
    file.writeAsString(row, mode: FileMode.append);
    return file;
  }

  Future<String> getDataFromFile() async {
    final file = await localFile;
    String data = settings.local.txt('set_nodata');
    if (await file.exists()) {
      data = file.readAsStringSync();
    }
    return data;
  }

  Future<void> setbackInitials() async {
    final prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    _dateString = prefs.getString('date') ?? stringDateNow();
    _energyRate = prefs.getInt('energyrate') ?? maxEnergyRate;
    _comment = prefs.getString('comment') ?? '';
    _spoonNb = prefs.getInt('spoonNb') ?? settings.maxSpoonNb;

    monthLastSession = prefs.getInt('monthlastsession') ?? monthLastSession;
    dayLastSession = prefs.getInt('daylastsession') ?? dayLastSession;
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
    await _writeData(_dateString, weekday, _energyRate, _spoonNb,
        settings.maxSpoonNb, _comment);

    DateTime now = DateTime.now();
    monthLastSession = now.month;
    dayLastSession = now.day;
    await prefs.setInt('monthlastsession', monthLastSession);
    await prefs.setInt('daylastsession', dayLastSession);
  }

  void checkLastSession() {
    DateTime now = DateTime.now();
    if (now.month != monthLastSession || now.day != dayLastSession) {
      updateEnergyRate(maxEnergyRate);
      String oldComment = _comment;
      _comment = '[Automatic maximum value reset]';
      logData();
      _comment = oldComment;
    }
  }
}

class Settings extends ChangeNotifier {
  int maxSpoonNb = 10;
  bool enableMaxSpoonReset = true;
  bool alreadyResetToday = false;
  bool enableReminder = false;
  bool _leftHanded = false;
  int reminderPeriod = 1;
  static int defaultResetMaxSpoonHour = 6;
  static int defaultHourStart = 9;
  static int defaultHourStop = 20;
  static String notificationTitle = "My Daily Spoon";
  static String notificationBody = 'Please check in your spoon';
  int hourStart = defaultHourStart;
  int minuteStart = 0;
  int hourStop = defaultHourStop;
  int minuteStop = 0;
  Localization local = Localization('en');
  String _birthYear = '2000';
  String _gender = 'F';
  String _usedLg = 'en';

  TimeOfDay resetMaxSpoonTime =
      TimeOfDay(hour: defaultResetMaxSpoonHour, minute: 0);
  TimeOfDay reminderStart = TimeOfDay(hour: defaultHourStart, minute: 0);
  TimeOfDay reminderStop = TimeOfDay(hour: defaultHourStop, minute: 0);
  late DateTime lastNotificationDate;
  late SpoonTracker spoonTracker;
  late final LocalNotificationService localNotificationService;
  Settings() {
    localNotificationService = LocalNotificationService();
    localNotificationService.initialize();
    setbackInitials();
  }

  bool get leftHanded {
    return _leftHanded;
  }

  set leftHanded(bool value) {
    _leftHanded = value;
    storeSettings();
    notifyListeners();
  }

  String get birthYear {
    return _birthYear;
  }

  set birthYear(String value) {
    _birthYear = value;
    storeSettings();
    notifyListeners();
  }

  String get gender {
    return _gender;
  }

  set gender(String value) {
    _gender = value;
    storeSettings();
    notifyListeners();
  }

  String get usedLg {
    return _usedLg;
  }

  set usedLg(String value) {
    _usedLg = value;
    storeSettings();
    notifyListeners();
  }

  Future<void> setbackInitials() async {
    final prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    String lg = prefs.getString('language') ?? Localization.defaultLanguage;
    updateLanguage(lg);
    maxSpoonNb = prefs.getInt('maxspoonNb') ?? maxSpoonNb;
    enableReminder = prefs.getBool('enablereminder') ?? enableReminder;
    _leftHanded = prefs.getBool('lefthanded') ?? _leftHanded;
    reminderPeriod = prefs.getInt('reminderperiod') ?? reminderPeriod;
    hourStart = prefs.getInt('reminderhourstart') ?? hourStart;
    minuteStart = prefs.getInt('reminderminutestart') ?? minuteStart;
    hourStop = prefs.getInt('reminderhourstop') ?? hourStop;
    minuteStop = prefs.getInt('reminderminutestop') ?? minuteStop;
    usedLg = prefs.getString('usedlg') ?? usedLg;
    gender = prefs.getString('gender') ?? gender;
    birthYear = prefs.getString('birthyear') ?? birthYear;

    reminderStart = TimeOfDay(hour: hourStart, minute: minuteStart);
    reminderStop = TimeOfDay(hour: hourStop, minute: minuteStop);
    DateTime now = DateTime.now();
    final String dtst = prefs.getString('lastnotificationdate') ?? '';
    if (dtst == '') {
      lastNotificationDate = now.add(const Duration(days: 7));
    } else {
      lastNotificationDate = DateTime.parse(dtst);
    }
    if (now.isAfter(lastNotificationDate)) {
      enableReminder = false;
    }
  }

  void updateMaxSpoonNb(int value, bool reset, TimeOfDay resetTime) {
    resetMaxSpoonTime = resetTime;
    enableMaxSpoonReset = reset;
    maxSpoonNb = value;
    storeSettings();
    notifyListeners();
  }

  String updateLanguage(String? lang) {
    local.language = lang ?? Localization.defaultLanguage;
    storeSettings();
    notifyListeners();
    return local.language;
  }

  Future<void> updateReminder(bool enabled, int period, TimeOfDay notifierStart,
      TimeOfDay notifierStop) async {
    localNotificationService.plugin.cancelAll();
    enableReminder = enabled;
    reminderPeriod = period;
    reminderStart = notifierStart;
    reminderStop = notifierStop;
    if (enableReminder) {
      lastNotificationDate =
          await localNotificationService.scheduleNotifications(
              notificationTitle,
              notificationBody,
              period,
              notifierStart,
              notifierStop);
    }
    storeSettings();
    notifyListeners();
  }

  Future<void> storeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', local.language);
    await prefs.setInt('maxspoonNb', maxSpoonNb);
    await prefs.setBool('enableReminder', enableReminder);
    await prefs.setBool('lefthanded', _leftHanded);
    await prefs.setInt('reminderperiod', reminderPeriod);
    hourStart = reminderStart.hour;
    minuteStart = reminderStart.minute;
    hourStop = reminderStop.hour;
    minuteStop = reminderStop.minute;
    await prefs.setInt('reminderhourstart', hourStart);
    await prefs.setInt('reminderminutestart', minuteStart);
    await prefs.setInt('reminderjourstop', hourStop);
    await prefs.setInt('reminderminutestop', minuteStop);
    String dtst = lastNotificationDate.toString();
    await prefs.setString('lastnotificationdate', dtst);
    await prefs.setString('gender', gender);
    await prefs.setString('usedlg', usedLg);
    await prefs.setString('birthyear', birthYear);
  }
}
