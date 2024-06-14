import 'package:flutter/material.dart';

class TimeDurationService {
  String isStartTimeBeforeEndTime({
    required List<TextEditingController> startControllers,
    required List<TextEditingController> endControllers,
  }) {
    // 시작 시간과 종료 시간을 분, 초로 변환
    int startHour = int.parse(startControllers[0].text);
    int startMinute = int.parse(startControllers[1].text);
    int startSecond = int.parse(startControllers[2].text);

    int endHour = int.parse(endControllers[0].text);
    int endMinute = int.parse(endControllers[1].text);
    int endSecond = int.parse(endControllers[2].text);

    // 시작 시간과 종료 시간을 초 단위로 계산
    int startTimeInSeconds = startHour * 3600 + startMinute * 60 + startSecond;
    int endTimeInSeconds = endHour * 3600 + endMinute * 60 + endSecond;

    // 종료 시간에서 시작 시간을 뺀 시간을 계산
    int durationInSeconds = endTimeInSeconds - startTimeInSeconds;

    // 음수면 잘못된 시간 범위
    if (durationInSeconds < 0) {
      return 'Invalid time range';
    }

    // 초를 시간, 분, 초로 변환
    int hours = durationInSeconds ~/ 3600;
    int minutes = (durationInSeconds % 3600) ~/ 60;
    int seconds = durationInSeconds % 60;

    // "00:00:30" 형식으로 변환
    String formattedDuration = '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';

    return formattedDuration;
  }

  void setEndTimeControllers({
    required List<TextEditingController> controllers,
    required int totalSeconds,
  }) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    controllers[0].text = hours.toString().padLeft(2, '0');
    controllers[1].text = minutes.toString().padLeft(2, '0');
    controllers[2].text = seconds.toString().padLeft(2, '0');
  }
}
