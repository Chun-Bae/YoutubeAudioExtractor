import 'package:flutter/material.dart';

class HomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF14181B), // 배경색 설정
        appBar: AppBar(
          backgroundColor: Color(0xFF14181B), // 앱바 배경색 설정
          title: Text(
            '환영해요!',
            style: TextStyle(
              color: Colors.white, // 텍스트 색상 설정
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '오디오를 추출해보세요!',
                style: TextStyle(
                  color: Colors.white, // 텍스트 색상 설정
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Input Youtube URL...',
                  labelStyle: TextStyle(color: Colors.white), // 라벨 텍스트 색상 설정
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF5963)),
                  ),
                ),
                style: TextStyle(color: Colors.white), // 입력 텍스트 색상 설정
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timer_rounded, color: Color(0xFFFF5963)),
                      SizedBox(width: 2),
                      Text(
                        "구간 설정",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ), // 텍스트 색상 설정
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: Color(0xFFFF5963),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF5963), width: 3.0),
                        ),
                      ),
                      style: TextStyle(color: Colors.white), // 입력 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    ':',
                    style: TextStyle(color: Colors.white), // 콜론 텍스트 색상 설정
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF5963), width: 3.0),
                        ),
                      ),
                      style: TextStyle(color: Colors.white), // 입력 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    ':',
                    style: TextStyle(color: Colors.white), // 콜론 텍스트 색상 설정
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF5963), width: 3.0),
                        ),
                      ),
                      style: TextStyle(color: Colors.white), // 입력 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '~',
                    style: TextStyle(color: Colors.white), // 물결 텍스트 색상 설정
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF5963), width: 3.0),
                        ),
                      ),
                      style: TextStyle(color: Colors.white), // 입력 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    ':',
                    style: TextStyle(color: Colors.white), // 콜론 텍스트 색상 설정
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF5963), width: 3.0),
                        ),
                      ),
                      style: TextStyle(color: Colors.white), // 입력 텍스트 색상 설정
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    ':',
                    style: TextStyle(color: Colors.white), // 콜론 텍스트 색상 설정
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 3.0),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFFF5963), width: 3.0),
                        ),
                      ),
                      style: TextStyle(color: Colors.white), // 입력 텍스트 색상 설정
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white, width: 3.0), // 활성화 상태 테두리 색상
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white, width: 3.0), // 포커스 상태 테두리 색상
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white, width: 3.0), // 기본 상태 테두리 색상
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                dropdownColor: Color(0xFF14181B), // 드롭다운 배경색 설정
                items: ['MP4', 'MP3'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style:
                            TextStyle(color: Colors.white)), // 드롭다운 텍스트 색상 설정
                  );
                }).toList(),
                iconEnabledColor: Color(0xFFFF5963), // 드롭다운 화살표 색상 설정
                onChanged: (newValue) {},
                hint: Text('MP4',
                    style: TextStyle(color: Colors.white)), // 힌트 텍스트 색상 설정
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5963), // 버튼 배경색 설정
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text('추출',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    )), // 버튼 텍스트 색상 설정
              ),
              SizedBox(height: 16),
              // LinearProgressIndicator(
              //   value: 0.9,
              //   backgroundColor: Colors.grey[300],
              //   valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5963)), // 프로그레스바 색상 설정
              //   minHeight: 30,
              // ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5963), // 버튼 배경색 설정
                  minimumSize: Size(double.infinity, 50), // 버튼 크기 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Color(0xFFFF5963)), // 버튼 테두리 색상 설정
                  ),
                ),
                child: Text(
                  'Download',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ), // 버튼 텍스트 색상 설정
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(HomePageWidget());
}
