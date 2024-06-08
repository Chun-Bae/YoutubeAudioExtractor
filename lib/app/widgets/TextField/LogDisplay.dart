import 'package:flutter/material.dart';

class LogDisplay extends StatelessWidget {
  final List<String> logs;
  final ScrollController scrollController;

  LogDisplay({required this.logs, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: logs.length,
        itemBuilder: (context, index) {
          return Text(
            logs[index],
            style: const TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }
}
