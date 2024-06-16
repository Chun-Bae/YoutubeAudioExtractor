import 'package:flutter/material.dart';

Widget GettingVideoTimeIndicator() {
  return SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 3.5,
    ),
  );
}
