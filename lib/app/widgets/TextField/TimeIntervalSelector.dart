import 'package:flutter/material.dart';
import 'TimeIntervalInput.dart';

class TimeIntervalSelector extends StatelessWidget {
  final bool isSegmentEnabled;
  final List<TextEditingController> startTimeControllers;
  final List<TextEditingController> endTimeControllers;

  TimeIntervalSelector({
    required this.isSegmentEnabled,
    required this.startTimeControllers,
    required this.endTimeControllers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TimeIntervalInput(
          isSegmentEnabled: isSegmentEnabled,
          timeController: startTimeControllers[0],
        ),
        const SizedBox(width: 8),
        const Text(
          ':',
          style: TextStyle(color: Colors.white),
        ),
        TimeIntervalInput(
          isSegmentEnabled: isSegmentEnabled,
          timeController: startTimeControllers[1],
        ),
        const SizedBox(width: 8),
        const Text(
          ':',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 8),
        TimeIntervalInput(
          isSegmentEnabled: isSegmentEnabled,
          timeController: startTimeControllers[2],
        ),
        const SizedBox(width: 8),
        const Text(
          '~',
          style: TextStyle(color: Colors.white),
        ),
        TimeIntervalInput(
          isSegmentEnabled: isSegmentEnabled,
          timeController: endTimeControllers[0],
        ),
        const SizedBox(width: 8),
        const Text(
          ':',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 8),
        TimeIntervalInput(
          isSegmentEnabled: isSegmentEnabled,
          timeController: endTimeControllers[1],
        ),
        const SizedBox(width: 8),
        const Text(
          ':',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 8),
        TimeIntervalInput(
          isSegmentEnabled: isSegmentEnabled,
          timeController: endTimeControllers[2],
        ),
      ],
    );
  }
}
