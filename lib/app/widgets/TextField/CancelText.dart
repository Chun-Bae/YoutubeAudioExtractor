import 'package:flutter/material.dart';

class CancelText extends StatefulWidget {
  const CancelText({super.key});

  @override
  State<CancelText> createState() => _CancelTextState();
}

class _CancelTextState extends State<CancelText> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '취소 중...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3.5,
          ),
        ),
      ],
    );
  }
}
