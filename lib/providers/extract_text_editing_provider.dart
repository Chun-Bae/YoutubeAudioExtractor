import 'package:flutter/material.dart';

class ExtractTextEditingProvider with ChangeNotifier {
  late String _videoTitle;

  final TextEditingController urlController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();
  final TextEditingController formatController = TextEditingController();
  final TextEditingController fileNameWithformatController =
      TextEditingController();
  final TextEditingController downloadedPathController =
      TextEditingController();
  final TextEditingController extractedPathController = TextEditingController();
  final List<TextEditingController> startTimeControllers = [
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
    TextEditingController(text: '00')
  ];
  final List<TextEditingController> endTimeControllers = [
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
    TextEditingController(text: '00')
  ];
  final TextEditingController durationTimeController = TextEditingController();

  // videoTitle
  String get videoTitle => _videoTitle;
  set videoTitle(String value) {
    _videoTitle = value;
    notifyListeners();
  }

  // url
  String get url => urlController.text;
  set url(String value) {
    urlController.text = value;
    notifyListeners();
  }

  // fileName
  String get fileName => fileNameController.text;
  set fileName(String value) {
    fileNameController.text = value;
    notifyListeners();
  }

  // format
  String get format => formatController.text;
  set format(String value) {
    formatController.text = value;
    notifyListeners();
  }

  // fileNameWithformat
  String get fileNameWithformat => fileNameWithformatController.text;
  set fileNameWithformat(String value) {
    fileNameWithformatController.text = value;
    notifyListeners();
  }

  // downloadedPath
  String get downloadedPath => downloadedPathController.text;
  set downloadedPath(String value) {
    downloadedPathController.text = value;
    notifyListeners();
  }

  // extractedPath
  String get extractedPath => extractedPathController.text;
  set extractedPath(String value) {
    extractedPathController.text = value;
    notifyListeners();
  }

  // startTime: "00:00:00"
  String get startTime => startTimeControllers.map((e) => e.text).join(':');
  // endTime: "00:00:00"
  String get endTime => endTimeControllers.map((e) => e.text).join(':');

  // durationTime "45" (seconds) : "00:00:00"은 변환 유틸 존재
  String get durationTime => durationTimeController.text;
  set durationTime(String value) {
    durationTimeController.text = value;
    notifyListeners();
  }

  @override
  void dispose() {
    urlController.dispose();
    fileNameController.dispose();
    fileNameWithformatController.dispose();
    formatController.dispose();
    downloadedPathController.dispose();
    extractedPathController.dispose();
    for (var controller in startTimeControllers) {
      controller.dispose();
    }
    for (var controller in endTimeControllers) {
      controller.dispose();
    }
    durationTimeController.dispose();
    super.dispose();
  }
}
