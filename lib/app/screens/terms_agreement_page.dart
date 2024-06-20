import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/extract_page.dart';
class TermsAgreementPage extends StatelessWidget {
  const TermsAgreementPage({super.key});

  Future<void> _agreeToTerms(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('termsAgreed', true);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => ExtractPage()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
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

  Widget _buildAgreeButton({required Function() onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF5963),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        '동의하고 계속하기',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF14181B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('서비스 약관 동의', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF14181B),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('서비스 약관'),
                    _buildSectionContent(
                      '제 1 조 (목적)\n이 약관은 유튜브 비디오 다운로드 및 추출 앱(이하 "앱")의 서비스 이용과 관련하여, 앱과 사용자의 권리, 의무 및 책임 사항을 규정함을 목적으로 합니다.',
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
                    SizedBox(height: 30),
                    const Divider(
                      color: Color.fromARGB(255, 83, 83, 83),
                      height: 30,
                      thickness: 3.0,
                    ),
                    _buildSectionTitle('개인정보 처리방침'),
                    _buildSectionContent(
                      '시행일: 2024년 6월 21일\n'
                      '\n유튜브 추출기(이하 “앱”)는 이용자의 개인정보를 매우 소중히 생각합니다. 앱은 이용자의 개인정보를 수집하지 않으며, 이용자의 \'동의를 기반으로 개인정보를 수집・이용 및 제공\'하고 있지 않습니다. 앱은 정보통신서비스제공자가 준수해야 하는 ‘개인정보 보호법’을 비롯한 관계 법령 및 개인정보보호 규정, 가이드라인을 준수하고 있습니다. “개인정보처리방침”이란 이용자의 소중한 개인정보를 보호함으로써 이용자가 안심하고 서비스를 이용할 수 있도록 앱이 준수해야 할 지침을 의미하며, 앱에서 언제든 확인할 수 있습니다. 본 개인정보처리방침은 앱이 제공하는 서비스에 적용됩니다.',
                    ),
                    _buildDivider(),
                    _buildSectionContent(
                      '1. 개인정보의 수집\n앱은 서비스 제공에 관한 계약 이행, 이용자 식별, 서비스 개발, 회원가입, 상담을 위하여 어떠한 개인정보도 수집하지 않습니다.',
                    ),
                    _buildDivider(),
                    _buildSectionContent(
                      '2. 개인정보의 목적과 이용\n앱은 개인정보를 수집하지 않으므로 수집한 개인정보를 이용할 목적도 없습니다.',
                    ),
                    _buildDivider(),
                    _buildSectionContent(
                      '3. 개인정보의 보유 및 이용 기간\n앱은 개인정보를 수집하지 않으므로, 개인정보의 보유 및 이용 기간이 적용되지 않습니다.',
                    ),
                    _buildDivider(),
                    _buildSectionContent(
                      '4. 개인정보의 파기\n앱은 개인정보를 수집하지 않으므로, 개인정보를 파기할 필요가 없습니다.',
                    ),
                    _buildDivider(),
                    _buildSectionContent(
                      '5. 이용자의 권리\n앱은 개인정보를 수집하지 않으므로, 이용자 및 만 14세 미만 이용자의 법정대리인의 권리가 적용되지 않습니다.',
                    ),
                    _buildDivider(),
                    _buildSectionContent(
                      '6. 개인정보 자동수집장치\n앱은 쿠키(cookie)와 세션(session) 등 개인정보 자동수집장치를 사용하지 않습니다.',
                    ),
                    _buildDivider(),
                    _buildSectionContent(
                      '7. 개인정보보호 담당조직\n앱은 개인정보를 수집하지 않으므로, 개인정보보호 담당조직이 필요하지 않습니다.',
                    ),
                    _buildDivider(),
                    _buildSectionContent(
                      '8. 안정성 확보 조치\n앱은 개인정보를 수집하지 않으므로, 개인정보의 안전성 확보 조치가 필요하지 않습니다.',
                    ),
                    _buildDivider(),
                    _buildSectionContent(
                      '9. 고지의무\n앱은 본 개인정보처리방침의 개정이 있는 경우, 시행 전에 공지사항 등을 통해 이용자에게 알리도록 하겠습니다. 다만 이용자의 권리와 관련된 중요한 변경이 있을 경우 시행하는 날로부터 30일 전에 알려드리겠습니다. 단, 서비스에 대한 새로운 기능에 관련된 변경이나 법률적인 사유로 인한 변경은 사전 공지 없이 즉시 발효될 수 있습니다.',
                    ),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildAgreeButton(onPressed: () => _agreeToTerms(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
