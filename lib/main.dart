import 'package:flutter/material.dart';
import 'app/screens/extract_page.dart';

void main() {
  runApp(ExtractApp());
}

class ExtractApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExtractPage(),
    );
  }
}
