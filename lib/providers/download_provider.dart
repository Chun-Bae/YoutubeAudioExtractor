import 'package:flutter/material.dart';

class DownloadProvider with ChangeNotifier {
  bool isDownloading = false;
  double downloadProgress = 0.0;

  void setDownloading(bool value) {
    isDownloading = value;
    notifyListeners();
  }

  void setDownloadProgress(double value) {
    downloadProgress = value;
    notifyListeners();
  }
}
