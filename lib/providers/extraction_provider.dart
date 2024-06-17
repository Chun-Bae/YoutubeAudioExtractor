import 'package:flutter/material.dart';

class ExtractionProvider with ChangeNotifier {
  bool _isGettingVideoTime = false;
  bool _isExtracting = false;
  bool _cancelExtract = false;
  double _extractProgress = 0.0;

  // isGettingVideoTime
  bool get isGettingVideoTime => _isGettingVideoTime;
  set isGettingVideoTime(bool value) {
    _isGettingVideoTime = value;
    notifyListeners();
  }

  //cancelExtract
  bool get cancelExtract => _cancelExtract;
  set cancelExtract(bool value) {
    _cancelExtract = value;
    notifyListeners();
  }

  // downloadProgress
  double get extractProgress => _extractProgress;
  set extractProgress(double progress) {
    _extractProgress = progress;
    notifyListeners();
  }

  // isExtracting
  bool get isExtracting => _isExtracting;
  set isExtracting(bool value) {
    _isExtracting = value;
    notifyListeners();
  }
}
