import 'package:flutter/material.dart';

class TimeSegmentToggle extends StatelessWidget {
  final bool isSegmentEnabled;
  final Function(bool) onToggle;

  TimeSegmentToggle({required this.isSegmentEnabled, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.timer_rounded, color: Color(0xFFFF5963)),
            SizedBox(width: 2),
            Text(
              "구간 설정",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Switch(
          value: isSegmentEnabled,
          onChanged: onToggle,
          activeColor: const Color(0xFFFF5963),
          inactiveTrackColor: const Color(0xFF14181B),
        ),
      ],
    );
  }
}
