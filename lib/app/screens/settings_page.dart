import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181B),
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0.0,
        title: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            '설정',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF14181B),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              '기타',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 83, 83, 83),
            height: 30,
            thickness: 3.0,
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: const Color(0xFFFF5963),
            ),
            title: Text(
              '도움말',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Navigate to Help Page
            },
          ),
          ListTile(
            leading: Icon(
              Icons.feedback_outlined,
              color: const Color(0xFFFF5963),
            ),
            title: Text(
              '건의사항',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Navigate to Feedback Page
            },
          ),
          ListTile(
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: const Color(0xFFFF5963),
            ),
            title: Text(
              '개인정보처리방침',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Navigate to Privacy Policy Page
            },
          ),
          ListTile(
            leading: Icon(
              Icons.article_outlined,
              color: const Color(0xFFFF5963),
            ),
            title: Text('서비스 약관',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            onTap: () {
              // Navigate to Terms of Service Page
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '© 2024. _bull, All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
