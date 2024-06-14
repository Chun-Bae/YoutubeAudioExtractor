import 'package:flutter/material.dart';

class FileNameInput extends StatelessWidget {
  final TextEditingController fileNameController;

  FileNameInput({required this.fileNameController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: fileNameController,
      decoration: const InputDecoration(
        labelText: '파일 이름',
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
