import 'package:flutter/material.dart';

class DownloadProvider with ChangeNotifier {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  // downloadProgress
  double get downloadProgress => _downloadProgress;
  set downloadProgress(double progress) {
    _downloadProgress = progress;
    notifyListeners();
  }

  // isDownloading
  bool get isDownloading => _isDownloading;
  set isDownloading(bool value) {
    _isDownloading = value;
    notifyListeners();
  }
}
