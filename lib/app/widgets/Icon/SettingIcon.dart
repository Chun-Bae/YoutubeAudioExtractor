import 'package:flutter/material.dart';

Widget SettingIcon({required Function() onPressed}) {
  return IconButton(
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(),
    iconSize: 26.0,
    icon: const Icon(
      Icons.settings_rounded,
      color: Color(0xFFFF5963),
    ),
    onPressed: onPressed,
  );
}
