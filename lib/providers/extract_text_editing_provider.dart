import 'package:flutter/material.dart';

class ExtractTextEditingProvider with ChangeNotifier {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();
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

  // url
  String get url => urlController.text;
  set url(String value) {
    urlController.text = value;
    notifyListeners();
  }

  // durationTime
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
