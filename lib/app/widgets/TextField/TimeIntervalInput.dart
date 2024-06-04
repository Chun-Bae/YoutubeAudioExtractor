import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget TimeIntervalInput({
  required bool isSegmentEnabled,
  required TextEditingController timeController,
}) {
  // FocusNode 인스턴스 생성
  FocusNode timeFocusNode = FocusNode();

// 포커스 상태 변경 이벤트 리스너 추가
  timeFocusNode.addListener(() {
    if (!timeFocusNode.hasFocus) {
      // 포커스가 끝났을 때
      if (timeController.text.isEmpty) {
        // 텍스트 필드가 비어있으면 '00'으로 설정
        timeController.text = '00';
      }
    }
  });
  
  return Expanded(
    child: Opacity(
      opacity: isSegmentEnabled ? 1.0 : 0.5,
      child: TextField(
        controller: timeController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: '00',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF5963), width: 3.0),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3.0),
          ),
        ),
        style: TextStyle(color: Colors.white),
        enabled: isSegmentEnabled,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^([0-5]?[0-9])$')),
        ],
        focusNode: timeFocusNode,
      ),
    ),
  );
}
