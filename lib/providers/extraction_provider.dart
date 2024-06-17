import 'package:flutter/material.dart';

class ExtractionProvider with ChangeNotifier {
  bool _isGettingVideoTime = false;
  bool isExtracting = false;
  bool _cancelExtract = false;
  double extractProgress = 0.0;

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

  void setExtracting(bool value) {
    isExtracting = value;
    notifyListeners();
  }

  void setExtractProgress(double value) {
    extractProgress = value;
    notifyListeners();
  }
}
