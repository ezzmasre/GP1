import 'package:flutter/foundation.dart';

class DistanceProvider with ChangeNotifier {
  double _distance = 0.0;
  int _calories = 0;
  double _water = 0.0;
  int _steps = 0;

  double get distance => _distance;
  int get calories => _calories;
  double get water => _water;
  int get steps => _steps;

  // Update all metrics when steps change
  void updateMetrics(int steps) {
    _steps = steps;
    _distance = (steps * 0.762) / 1000; // Calculate distance from steps
    _calories = (steps * 0.04).round(); // Calculate calories from steps
    notifyListeners();
  }

  void updateWater(double water) {
    _water = water;
    notifyListeners();
  }
}