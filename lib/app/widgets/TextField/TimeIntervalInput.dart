import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget TimeIntervalInput({
  required bool isSegmentEnabled,
  required TextEditingController timeController,
}) {
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
      ),
    ),
  );
}
