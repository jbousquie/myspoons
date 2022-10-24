// https://www.freecodecamp.org/news/provider-pattern-in-flutter/
import 'package:flutter/foundation.dart';

class SpoonTracker extends ChangeNotifier {
  int _energyRate = 50;
  int _spoonNb = 5;

  int get energyRate {
    return _energyRate;
  }

  int get spoonNb {
    return _spoonNb;
  }

  void updateEnergyRate(int value) {
    _energyRate = value;
    _updateSpoonNb();
  }

  void _updateSpoonNb() {
    _spoonNb = (_energyRate * 0.1).round();
  }
}
