import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  Widget _HelpUsingMethod({required String imagePath}) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 146, 146, 146), width: 1.0),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _HelpDownloadPath({required String imagePath}) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(255, 146, 146, 146), width: 1.0),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
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
        titleSpacing: 0.0,
        title: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            '도움말',
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
        padding: const EdgeInsets.all(10.0),
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              '사용 방법',
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
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "1. 동영상 URL을 입력하고 '추출' 버튼을 누릅니다.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _HelpUsingMethod(imagePath: 'assets/help/help_01.png'),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "2. 원하는 동영상 구간을 설정할 수 있습니다. (선택)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _HelpUsingMethod(imagePath: 'assets/help/help_02.png'),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "선택을 하지 않아도 유효한 주소일 경우 자동으로 전체 영상 길이가 저장됩니다.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "3. '포맷'을 선택합니다.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _HelpUsingMethod(imagePath: 'assets/help/help_03.png'),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "동영상의 경우, mp4와 avi가 자주 사용됩니다.\n오디오의 경우, mp3가 자주 사용됩니다.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "4. '파일 이름'을 설정합니다.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _HelpUsingMethod(imagePath: 'assets/help/help_04.png'),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "만약 설정하지 않으면 동영상의 제목이 extract_file로 저장됩니다.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 75.0),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              '다운로드 위치(안드로이드)',
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "다운로드 위치는 \n'내 파일' > '내장 메모리' > 'Documents' 폴더입니다.\n아래 그림을 통해 자세히 확인할 수 있습니다. ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          _HelpDownloadPath(imagePath: 'assets/help/help_05.png'),
          _HelpDownloadPath(imagePath: 'assets/help/help_06.png'),
          _HelpDownloadPath(imagePath: 'assets/help/help_07.png'),
          _HelpDownloadPath(imagePath: 'assets/help/help_08.png'),
        ],
      ),
    );
  }
}
