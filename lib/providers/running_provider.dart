import 'package:flutter/foundation.dart';

class RunningProvider with ChangeNotifier {
  double _runningDistance = 0;

  double get runningDistance => _runningDistance;

  void updateRunningDistance(double distance) {
    _runningDistance = distance;
    notifyListeners();
  }
}