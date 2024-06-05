import 'package:flutter/material.dart';

Widget InvalidTimeRangeDialog(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Color(0xFF0E0E0E),
    surfaceTintColor: Color(0xFF0E0E0E),
    contentPadding: EdgeInsets.all(30),
    content: Text(
      '구간이 잘못됐습니다!',
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    ),
    actions: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5963),
                minimumSize: Size(double.infinity, 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                '확인',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    ],
  );
}
