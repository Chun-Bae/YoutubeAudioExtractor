import 'dart:io';
import 'package:flutter/material.dart';

import '../app/widgets/Dialog/ExtractErrorDialog.dart';

class LogProvider with ChangeNotifier {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();

  List<String> get logs => _logs;
  ScrollController get scrollController => _scrollController;

  void writeLog(String message) {
    print(message);
    _logs.add(message);
    notifyListeners();
  }

  String getErrorMessage(dynamic error) {
    if (error is ArgumentError && error.message == 'format') {
      return '포맷을 지정해주세요!';
    } else if (error is ArgumentError && error.message == 'Download cancelled') {
      return 'Download cancelled';
    } else if (error is ArgumentError) {
      return "URL을 잘못 입력하셨습니다.\nYouTube 주소를 확인해주세요.";
    } else if (error is PathNotFoundException) {
      return "천천히 눌러 주세요!";
    } else if (error is Exception) {
      return "알 수 없는 에러가 발생했습니다!";
    } else {
      return error.toString();
    }
  }

  void handleError(BuildContext context, dynamic error) {
    final errorMessage = getErrorMessage(error);
    writeLog("Error: $error, type: ${error.runtimeType}");
    if(errorMessage == 'Download cancelled') {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExtractErrorDialog(context, errorMessage);
      },
    );
  }

  // UI 표시 필요 시에 사용
  void handleScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
