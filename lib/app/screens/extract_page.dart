import 'package:flutter/material.dart';
import '../widgets/TextField/TimeIntervalInput.dart';
import '../widgets/Button/WidthFullButton.dart';
import '../../services/time_validation.dart';

class ExtractPage extends StatefulWidget {
  @override
  _ExtractPageState createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> {
  TextEditingController _urlController = TextEditingController();

  final List<TextEditingController> _startTimeControllers = [
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
  ];
  final List<TextEditingController> _endTimeControllers = [
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
  ];

  bool _isSegmentEnabled = false;

  void _toggleSegment(bool value) {
    setState(() {
      _isSegmentEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  value: _isSegmentEnabled,
                  onChanged: _toggleSegment,
                  activeColor: Color(0xFFFF5963),
                  inactiveTrackColor: Color(0xFF14181B),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TimeIntervalInput(
                  isSegmentEnabled: _isSegmentEnabled,
                  timeController: _startTimeControllers[0],
                ),
                SizedBox(width: 8),
                Text(
                  ':',
                  style: TextStyle(color: Colors.white),
                ),
                TimeIntervalInput(
                  isSegmentEnabled: _isSegmentEnabled,
                  timeController: _startTimeControllers[1],
                ),
                SizedBox(width: 8),
                Text(
                  ':',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                TimeIntervalInput(
                  isSegmentEnabled: _isSegmentEnabled,
                  timeController: _startTimeControllers[2],
                ),
                SizedBox(width: 8),
                Text(
                  '~',
                  style: TextStyle(color: Colors.white),
                ),
                TimeIntervalInput(
                  isSegmentEnabled: _isSegmentEnabled,
                  timeController: _endTimeControllers[0],
                ),
                SizedBox(width: 8),
                Text(
                  ':',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                TimeIntervalInput(
                  isSegmentEnabled: _isSegmentEnabled,
                  timeController: _endTimeControllers[1],
                ),
                SizedBox(width: 8),
                Text(
                  ':',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                TimeIntervalInput(
                  isSegmentEnabled: _isSegmentEnabled,
                  timeController: _endTimeControllers[2],
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
              items: [
                DropdownMenuItem<String>(
                  value: "video",
                  enabled: false,
                  child: Text(
                    "비디오 포맷",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ...[
                  'MP4',
                  'AVI',
                  'MKV',
                  'MOV',
                  'FLV',
                  'WMV',
                  'MPEG',
                  'WEBM',
                  'OGV',
                  'TS'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style:
                            TextStyle(color: Colors.white)), // 드롭다운 텍스트 색상 설정
                  );
                }).toList(),
                DropdownMenuItem<String>(
                  value: "audio",
                  enabled: false,
                  child: Text(
                    "오디오 포맷",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ...['MP3', 'WAV', 'AAC', 'FLAC', 'OGG', 'M4A', 'WMA', 'OPUS']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style:
                            TextStyle(color: Colors.white)), // 드롭다운 텍스트 색상 설정
                  );
                }).toList(),
              ],
              iconEnabledColor: Color(0xFFFF5963), // 드롭다운 화살표 색상 설정
              onChanged: (newValue) {
                // 선택된 값 처리
              },
              hint: Text(
                'Select Format',
                style: TextStyle(color: Colors.white), // 힌트 텍스트 색상 설정
              ),
            ),
            SizedBox(height: 16),
            WidthFullButton(
              text: '추출',
              onPressed: () {
                if (TimeValidationService().isStartTimeBeforeEndTime(
                  startControllers: _startTimeControllers,
                  endControllers: _endTimeControllers,
                )) {
                  // 추출 로직
                } else {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color(0xFF0E0E0E),
                        surfaceTintColor: Color(0xFF0E0E0E),
                        contentPadding: EdgeInsets.all(30),
                        content: Text(
                          '구간이 잘못됐습니다!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFFF5963),
                                    minimumSize: Size(double.infinity, 35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    '확인',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(height: 16),
            WidthFullButton(
              text: 'Download',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
