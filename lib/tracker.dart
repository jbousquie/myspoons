// https://www.freecodecamp.org/news/provider-pattern-in-flutter/

// https://davidserrano.io/best-way-to-handle-permissions-in-your-flutter-app

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';

class SpoonTracker extends ChangeNotifier {
  late int _energyRate = 50;
  late int _spoonNb = _computeSpoonNb(_energyRate);
  late String _comment = '';
  late String _dateString = DateTime.now().toString().substring(0, 19);
  final String _filename = 'myspoons.csv';
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
    return (value / 12.5).round();
  }

  Future<String> get _localPath async {
    final directory =
        (await getExternalStorageDirectories(type: StorageDirectory.downloads))!
            .first;
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_filename');
  }

  Future<File> writeData(
      String dateString, int energyRate, String comment) async {
    final file = await _localFile;
    final bool hasFilePersmission = await requestFilePermission();
    if (hasFilePersmission) {
      final row = '$dateString;$energyRate;$comment\n';
      file.writeAsString(row, mode: FileMode.append);
    }
    return file;
  }

  Future<void> setbackInitials() async {
    final prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    _dateString =
        prefs.getString('date') ?? DateTime.now().toString().substring(0, 19);
    _energyRate = prefs.getInt('energyrate') ?? 50;
    _comment = prefs.getString('comment') ?? '';
    notifyListeners();
  }

  Future<void> logData(String dateString, int value, String comment) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('date', dateString);
    await prefs.setInt('energyrate', value);
    await prefs.setString('comment', comment);
    await writeData(dateString, energyRate, comment);
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
