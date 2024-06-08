import 'package:flutter/material.dart';
import 'FormatDropdownMenu.dart'; // FormatDropdownMenu import

class FormatDropdown extends StatelessWidget {
  final List<String> audioFormats;
  final List<String> videoFormats;
  final Function(String?)? onChanged;

  FormatDropdown({
    required this.audioFormats,
    required this.videoFormats,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3.0),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3.0),
          borderRadius: BorderRadius.circular(8),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3.0),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dropdownColor: const Color(0xFF14181B),
      items: [
        ...FormatDropdownMenu(
                categoryName: '비디오 포맷',
                items: audioFormats,
                value: 'audio')
            .getDropdownMenuItems(),
        ...FormatDropdownMenu(
                categoryName: '비디오 포맷',
                items: videoFormats,
                value: 'video')
            .getDropdownMenuItems(),
      ],
      iconEnabledColor: const Color(0xFFFF5963),
      onChanged: onChanged,
      hint: const Text(
        'Select Format',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
