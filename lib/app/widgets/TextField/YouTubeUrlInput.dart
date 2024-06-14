import 'package:flutter/material.dart';

class YouTubeUrlInput extends StatelessWidget {
  final TextEditingController urlController;
  final Future<void> Function(String) onChangeFunc;

  YouTubeUrlInput({
    required this.urlController,
    required this.onChangeFunc,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: urlController,
      onChanged: (url) {
        onChangeFunc(url);
      },
      decoration: const InputDecoration(
        labelText: 'Input Youtube URL...',
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
