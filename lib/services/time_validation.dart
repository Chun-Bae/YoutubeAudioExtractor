import 'package:flutter/material.dart';

class TimeValidationService {
  bool isStartTimeBeforeEndTime({ required List<TextEditingController> startControllers, required List<TextEditingController> endControllers}) {
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

    // 시작 시간이 종료 시간보다 이전인지 확인
    return startTimeInSeconds <= endTimeInSeconds;
  }
}