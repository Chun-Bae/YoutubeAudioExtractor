import 'package:flutter/material.dart';
import '../widgets/TextField/TimeIntervalInput.dart';
import '../widgets/Button/WidthFullButton.dart';
import '../widgets/Dropdown/FormatDropdownMenu.dart';
import '../widgets/Dialog/InvalidTimeRangeDialog.dart';
import '../../services/time_validation.dart';
import '../../services/video_service.dart';
import '../../services/ffmpeg_service.dart';

class ExtractPage extends StatefulWidget {
  @override
  _ExtractPageState createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> {
  TextEditingController _urlController = TextEditingController();
  final List<String> audioFormats = [
    'MP3',
    'WAV',
    'FLAC',
    'AAC',
    'WMA',
    'OGG',
    'M4A',
    'AMR',
    'AIFF',
    'AU'
  ];
  final List<String> videoFormats = [
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
  ];
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
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Input Youtube URL...',
                labelStyle: TextStyle(color: Colors.white), // 라벨 텍스트 색상 설정
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF5963)),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 3.0),
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
                ...FormatDropdownMenu(
                        categoryName: '비디오 포맷',
                        items: audioFormats,
                        value: 'video')
                    .getDropdownMenuItems(),
                ...FormatDropdownMenu(
                        categoryName: '비디오 포맷',
                        items: videoFormats,
                        value: 'video')
                    .getDropdownMenuItems(),
              ],
              iconEnabledColor: Color(0xFFFF5963),
              onChanged: (newValue) {
                // 선택된 값 처리
              },
              hint: Text(
                'Select Format',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            WidthFullButton(
              text: '추출',
              onPressed: () async {
                if (TimeValidationService().isStartTimeBeforeEndTime(
                  startControllers: _startTimeControllers,
                  endControllers: _endTimeControllers,
                )) {
                  VideoService videoService = VideoService();
                  FFmpegService ffmpegService = FFmpegService();

                  await videoService.downloadYouTubeVideo(_urlController.text);
                  await ffmpegService.extractVideoSegment(
                      '00:00:10',
                      '00:00:30'.toString().split('.').first);
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return InvalidTimeRangeDialog(context);
                    },
                  );
                } else {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return InvalidTimeRangeDialog(context);
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
