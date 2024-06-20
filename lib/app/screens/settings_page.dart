import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _sendFeedbackEmail(BuildContext context) async {
    final Email email = Email(
      body: '',
      subject: '[유튜브 추출기 문의]',
      recipients: ['dbtjrdla2056@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text(
                '이메일 클라이언트를 찾을 수 없습니다. 이메일 클라이언트가 설치되어 있는지 확인해주세요.\n\n기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\ndbtjrdla2056@gmail.com'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

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
            onTap: () => Navigator.pushNamed(context, '/settings/help'),
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
            onTap: () => _sendFeedbackEmail(context),
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
