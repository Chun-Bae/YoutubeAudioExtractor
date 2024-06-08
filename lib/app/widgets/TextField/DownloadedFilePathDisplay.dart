// Downloaded File Path Display: 디버깅 확인을 위한 다운로드된 파일 경로를 표시하는 TextField 위젯
import 'package:flutter/material.dart';

class DownloadedFilePathDisplay extends StatelessWidget {
  final TextEditingController downloadedFilePathController;

  DownloadedFilePathDisplay({required this.downloadedFilePathController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: downloadedFilePathController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Downloaded File Path...',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFFF5963)),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3.0),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
