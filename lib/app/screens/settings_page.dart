import 'package:flutter/material.dart';
import 'package:youtube_audio_extractor/providers/ad_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../services/send_feedback_email_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SendFeedbackEmailService _sendFeedbackEmailService =
      SendFeedbackEmailService();
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
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
      bottomNavigationBar: Consumer<AdProvider>(
        builder: (context, adProvider, child) {
          if (adProvider.isAdLoaded && adProvider.bannerAd != null) {
            return Container(
              height: adProvider.bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: adProvider.bannerAd!),
            );
          } else {
            return Container();
          }
        },
      ),
      backgroundColor: const Color(0xFF14181B),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
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
            onTap: () => _sendFeedbackEmailService.sendFeedbackEmail(context),
          ),
          _settingListTile(
            title: '개인정보처리방침',
            icon: Icons.privacy_tip_outlined,
            onTap: () =>
                _launchURL('https://sites.google.com/view/yt-extract-privacy/'),
          ),
          _settingListTile(
            title: '서비스 약관',
            icon: Icons.article_outlined,
            onTap: () => Navigator.pushNamed(context, '/settings/terms'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '© 2024. bull_, All rights reserved.',
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
