import 'package:flutter/material.dart';

Widget ExtractCancelButton({required Function() onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFF5963),
      minimumSize: Size(100, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    child: Text('취소',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        )),
  );
}
