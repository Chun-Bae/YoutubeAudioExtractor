import 'package:flutter/material.dart';

class FormatDropdownMenu {
  final String categoryName;
  final List<String> items;
  final String value;
  FormatDropdownMenu(
      {required this.categoryName, required this.items, required this.value});



  List<DropdownMenuItem<String>> getDropdownMenuItems() {
    return <DropdownMenuItem<String>>[
      DropdownMenuItem<String>(
        value: value,
        enabled: false,
        child: Text(
          categoryName,
          style: TextStyle(color: Colors.grey),
        ),
      ),
      ...items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
    ];
  }
}
