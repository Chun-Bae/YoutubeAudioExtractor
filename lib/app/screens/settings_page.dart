import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:youtube_audio_extractor/providers/ad_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../widgets/Dialog/SendFeedbackEmailErrorDialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AdProvider>(context, listen: false).createBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<AdProvider>(context, listen: false).disposeAd();
  }

  Future<Map<String, dynamic>> _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return {
      "App Name": packageInfo.appName,
      "Package Name": packageInfo.packageName,
      "Version": packageInfo.version,
      "Build Number": packageInfo.buildNumber,
    };
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData;

    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData = {
        "Device": androidInfo.model,
        "Android Version": androidInfo.version.release,
        "SDK": androidInfo.version.sdkInt,
      };
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData = {
        "Device": iosInfo.utsname.machine,
        "iOS Version": iosInfo.systemVersion,
      };
    } else {
      deviceData = {
        "Platform": "Unknown",
      };
    }

    return deviceData;
  }

  Future<String> _getEmailBody() async {
    Map<String, dynamic> appInfo = await _getAppInfo();
    Map<String, dynamic> deviceInfo = await _getDeviceInfo();

    String body = "";

    body += "==============\n";

    appInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    deviceInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    body += "==============\n";

    return body;
  }

  Future<void> _sendFeedbackEmail(BuildContext context) async {
    String body = await _getEmailBody();
    const String sendFeedbackEmailErrorText =
        '이메일 클라이언트를 찾을 수 없습니다. 이메일 클라이언트가 설치되어 있는지 확인해주세요.\n\n기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드리겠습니다.  :)\n\ndbtjrdla2056@gmail.com';
    final Email email = Email(
      body: body,
      subject: '[유튜브 추출기 앱 문의]',
      recipients: ['dbtjrdla2056@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      throw 'Error';
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Error: $error');
      sendFeedbackEmailErrorDialog(context, sendFeedbackEmailErrorText);
    }
  }

  Widget _settingListTile({
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFFF5963),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final adProvider = Provider.of<AdProvider>(context, listen: false);
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
      bottomNavigationBar: adProvider.isAdLoaded
          ? Container(
              height: adProvider.bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: adProvider.bannerAd!),
            )
          : Container(),
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
          _settingListTile(
            title: '도움말',
            icon: Icons.help_outline,
            onTap: () => Navigator.pushNamed(context, '/settings/help'),
          ),
          _settingListTile(
            title: '건의사항',
            icon: Icons.feedback_outlined,
            onTap: () => _sendFeedbackEmail(context),
          ),
          _settingListTile(
            title: '개인정보처리방침',
            icon: Icons.privacy_tip_outlined,
            onTap: () => {},
          ),
          _settingListTile(
            title: '서비스 약관',
            icon: Icons.article_outlined,
            onTap: () => {},
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
