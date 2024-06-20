import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppLicensePage extends StatelessWidget {
  const AppLicensePage({super.key});
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildLicenseItem({
    required String title,
    required String license,
    required String url,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            license,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4.0),
          InkWell(
            onTap: () => _launchURL(url),
            child: Text(
              url,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 83, 83, 83),
            height: 30,
            thickness: 1.0,
          ),
        ],
      ),
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
            '라이선스 정보',
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
        padding: const EdgeInsets.all(16.0),
        children: [
          const Divider(
            color: Color.fromARGB(255, 83, 83, 83),
            height: 30,
            thickness: 3.0,
          ),
          Text(
            '오픈 소스 라이브러리',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '이 앱은 다음의 오픈 소스 라이브러리를 사용하고 있습니다:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildLicenseItem(
            title: 'flutter',
            license: 'MIT License',
            url: 'https://github.com/flutter/flutter',
            description:
                'MIT License는 매우 자유로운 라이선스로, 소프트웨어의 복사, 수정, 배포를 허용하며, 소프트웨어의 사용에 대한 제한이 거의 없습니다. 사용자는 소프트웨어의 모든 복사본이나 중요한 부분에 원본 저작권 고지와 함께 위의 권고사항을 명시해야 합니다.',
          ),
          _buildLicenseItem(
            title: 'youtube_explode_dart',
            license: 'MIT License',
            url: 'https://github.com/Hexer10/youtube_explode_dart',
            description:
                'MIT License는 매우 자유로운 라이선스로, 소프트웨어의 복사, 수정, 배포를 허용하며, 소프트웨어의 사용에 대한 제한이 거의 없습니다. 사용자는 소프트웨어의 모든 복사본이나 중요한 부분에 원본 저작권 고지와 함께 위의 권고사항을 명시해야 합니다.',
          ),
          _buildLicenseItem(
            title: 'flutter_local_notifications',
            license: 'BSD 3-Clause License',
            url: 'https://github.com/MaikuB/flutter_local_notifications',
            description:
                'BSD 3-Clause License는 수정, 배포를 허용하며, 저작권 고지와 함께 모든 배포에 명시해야 합니다. 이 라이선스는 광고 목적으로 프로젝트 명칭을 사용할 수 없도록 제한합니다.',
          ),
          _buildLicenseItem(
            title: 'FFmpeg',
            license: 'LGPL License',
            url: 'https://ffmpeg.org/',
            description:
                'LGPL License는 소프트웨어를 자유롭게 사용할 수 있으며, 수정 및 배포가 가능합니다. 단, 수정된 소스 코드를 공개해야 하고, LGPL 라이선스를 유지해야 합니다.',
          ),
          Text(
            '각 라이브러리의 라이선스 전문을 확인하려면 해당 링크를 클릭하세요.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
