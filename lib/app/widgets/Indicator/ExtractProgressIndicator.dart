import 'package:flutter/material.dart';

class ExtractProgressIndicator extends StatelessWidget {
  final double progress;

  ExtractProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          valueColor: AlwaysStoppedAnimation<Color>(
            const Color(0xFFFF5963),
          ),
          minHeight: 15,
        ),
        const SizedBox(height: 8),
        Text(
          '${(progress * 100).round()}%',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
