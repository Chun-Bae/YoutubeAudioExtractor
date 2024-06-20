import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color.fromARGB(255, 83, 83, 83),
      height: 30,
      thickness: 1.0,
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
            '서비스 약관',
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
          _buildSectionTitle('제 1 조 (목적)'),
          _buildSectionContent(
            '이 약관은 유튜브 비디오 다운로드 및 추출 앱(이하 "앱")의 서비스 이용과 관련하여, 앱과 사용자의 권리, 의무 및 책임 사항을 규정함을 목적으로 합니다.',
          ),
          _buildDivider(),
          _buildSectionTitle('제 2 조 (정의)'),
          _buildSectionContent(
            '1. "서비스"란 앱이 제공하는 모든 기능을 의미합니다.\n2. "사용자"란 본 약관에 따라 앱이 제공하는 서비스를 이용하는 개인 또는 법인을 의미합니다.',
          ),
          _buildDivider(),
          _buildSectionTitle('제 3 조 (약관의 게시와 개정)'),
          _buildSectionContent(
            '1. 앱은 이 약관의 내용을 사용자가 쉽게 알 수 있도록 앱 내에 게시합니다.\n2. 앱은 관련 법령을 위배하지 않는 범위에서 이 약관을 개정할 수 있으며, 약관을 개정할 경우 개정 내용을 앱 내에 공지합니다.',
          ),
          _buildDivider(),
          _buildSectionTitle('제 4 조 (개인정보의 보호)'),
          _buildSectionContent(
            '앱은 사용자의 개인정보를 수집하지 않습니다. 사용자는 별도의 개인정보 입력 없이 앱을 사용할 수 있으며, 모든 데이터는 사용자의 기기에만 저장됩니다.',
          ),
          _buildDivider(),
          _buildSectionTitle('제 5 조 (서비스의 제공 및 변경)'),
          _buildSectionContent(
            '1. 앱은 다음과 같은 서비스를 제공합니다:\n  - 유튜브 비디오 다운로드 및 추출\n2. 앱은 필요한 경우 서비스의 내용을 변경할 수 있으며, 변경 시 그 사유 및 내용을 사전에 사용자에게 공지합니다.',
          ),
          _buildDivider(),
          _buildSectionTitle('제 6 조 (서비스의 중단)'),
          _buildSectionContent(
            '앱은 천재지변, 시스템 오류 등 불가피한 사유가 발생한 경우 서비스의 제공을 일시적으로 중단할 수 있습니다. 이 경우 앱은 사용자에게 사전에 공지합니다.',
          ),
          _buildDivider(),
          _buildSectionTitle('제 7 조 (저작권)'),
          _buildSectionContent(
            '1. 사용자는 저작권법을 준수해야 합니다. 유튜브 및 기타 플랫폼에서 저작권이 있는 콘텐츠를 다운로드하는 것은 저작권자의 허락 없이는 불법입니다.\n2. 앱은 저작권이 있는 콘텐츠를 무단으로 다운로드하거나 변환하는 행위를 지원하지 않습니다.\n3. 사용자가 저작권법을 위반하여 발생하는 모든 법적 책임은 사용자 본인에게 있습니다. 앱은 사용자의 저작권 침해 행위에 대해 어떠한 책임도 지지 않습니다.',
          ),
          _buildDivider(),
          _buildSectionTitle('제 8 조 (책임의 제한)'),
          _buildSectionContent(
            '1. 앱은 사용자의 귀책 사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다.\n2. 앱은 사용자가 서비스를 이용하여 기대하는 수익을 얻지 못한 것에 대해 책임을 지지 않습니다.',
          ),
          _buildDivider(),
          _buildSectionTitle('제 9 조 (사용자의 의무)'),
          _buildSectionContent(
            '1. 사용자는 서비스 이용 시 다음 행위를 하여서는 안 됩니다:\n  - 타인의 저작권, 초상권 등 권리를 침해하는 행위\n  - 법령에 위반되는 행위\n2. 사용자는 앱의 운영 정책 및 관련 법령을 준수해야 합니다.',
          ),
          _buildDivider(),
          _buildSectionTitle('제 10 조 (기타)'),
          _buildSectionContent(
            '이 약관에 명시되지 않은 사항에 대해서는 관련 법령에 따릅니다.',
          ),
        ],
      ),
    );
  }
}
