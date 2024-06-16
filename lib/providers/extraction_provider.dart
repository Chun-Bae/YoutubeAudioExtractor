import 'package:flutter/material.dart';

class ExtractionProvider with ChangeNotifier {
  bool isExtracting = false;
  bool cancelExtract = false;
  double extractProgress = 0.0;

  void setExtracting(bool value) {
    isExtracting = value;
    notifyListeners();
  }

  void setCancelExtract(bool value) {
    cancelExtract = value;
    notifyListeners();
  }

  void setExtractProgress(double value) {
    extractProgress = value;
    notifyListeners();
  }
}
