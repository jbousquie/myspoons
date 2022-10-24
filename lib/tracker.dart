// https://www.freecodecamp.org/news/provider-pattern-in-flutter/
import 'package:flutter/foundation.dart';

class SpoonTracker extends ChangeNotifier {
  double _energyRate = 50;
  int _spoonNb = 5;

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
}
