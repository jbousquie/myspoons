// https://www.freecodecamp.org/news/provider-pattern-in-flutter/
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpoonTracker extends ChangeNotifier {
  late double _energyRate = 50;
  late int _spoonNb;
  SpoonTracker() {
    setbackInitials();
  }

  double get energyRate {
    return _energyRate;
  }

  int get spoonNb {
    return _spoonNb;
  }

  void updateEnergyRate(double value) {
    _energyRate = value;
    _updateSpoonNb();
    notifyListeners();
  }

  void _updateSpoonNb() {
    _spoonNb = (_energyRate * 0.1).round();
  }

  Future<void> setbackInitials() async {
    final prefs = await SharedPreferences.getInstance();
    _energyRate = prefs.getDouble('energyrate') ?? 50;
    notifyListeners();
  }

  Future<void> logData(double value, String comment) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('energyrate', value);
    await prefs.setString('comment', comment);
  }
}
