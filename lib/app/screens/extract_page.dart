import '../widgets/AppBar/WelcomeAppBar.dart';
import '../widgets/TextField/TimeIntervalSelector.dart';
import '../widgets/TextField/YouTubeUrlInput.dart';
import '../widgets/TextField/ExtractInstructionText.dart';
import '../widgets/Button/ExtractButton.dart';
import '../widgets/Dropdown/FormatDropdown.dart';
import '../widgets/Indicator/ExtractProgressIndicator.dart';
import '../widgets/Dialog/InvalidTimeRangeDialog.dart';
import '../widgets/Toggle/TimeSegmentToggle.dart';
import '../../services/time_validation.dart';
import '../../services/video_service.dart';
import '../../services/ffmpeg_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExtractPage extends StatefulWidget {
  @override
  _ExtractPageState createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> {
  TextEditingController _urlController = TextEditingController();
  TextEditingController _downloadedFilePathController = TextEditingController();
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
    TextEditingController(text: '00')
  ];
  final List<TextEditingController> _endTimeControllers = [
    TextEditingController(text: '00'),
    TextEditingController(text: '00'),
    TextEditingController(text: '00')
  ];
  bool _isSegmentEnabled = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late String downloadedFilePath;
  List<String> _logs = []; // 로그 메시지를 저장할 리스트
  final ScrollController _scrollController = ScrollController();

  bool _isExtracting = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        await _openDownloadDirectory();
      }
    });
  }

  Future<void> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // 권한이 승인되었습니다.
      _log('Storage permission granted.');
    } else {
      // 권한이 거부되었습니다.
      _log('Storage permission denied.');
    }
  }

  void _toggleSegment(bool value) {
    setState(() {
      _isSegmentEnabled = value;
    });
  }

  Future<void> _showNotification(
      String title, String body, String directoryPath) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: directoryPath);
  }

  Future<void> _openDownloadDirectory() async {
    try {
      Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        _log("Could not get the external storage directory");
        return;
      }

      String documentsPath = '${directory.path}/Documents';
      Directory documentsDirectory = Directory(documentsPath);

      if (await documentsDirectory.exists()) {
        _log('Directory exists: $documentsPath');
      } else {
        _log('Directory does not exist: $documentsPath');
        await documentsDirectory.create(recursive: true);
        _log('Directory created: $documentsPath');
      }

      // Use FilePicker to open the directory picker starting at the Documents directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        _log('Directory selected: $selectedDirectory');
      } else {
        _log('User canceled the picker');
      }
    } catch (e) {
      _log("Could not open directory: $e");
    }
  }

  Future<void> _downloadVideo() async {
    if (TimeValidationService().isStartTimeBeforeEndTime(
      startControllers: _startTimeControllers,
      endControllers: _endTimeControllers,
    )) {
      _log("Time validation passed");
      VideoService videoService = VideoService();
      FFmpegService ffmpegService = FFmpegService();

      setState(() {
        _isExtracting = true;
        _progress = 0.0;
      });

      _log("Starting video download");
      await videoService.downloadYouTubeVideo(_urlController.text, (progress) {
        setState(() {
          _progress = progress;
        });
      }).catchError((e) {
        _log("Video download error: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Video download error: $e"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
      _log("Video download completed");

      setState(() {
        downloadedFilePath = videoService.downloadedFilePath;
        _downloadedFilePathController.text = downloadedFilePath;
        _progress = 0.5; // 다운로드 완료 후 중간 진행률 설정
      });

      final directoryPath =
          downloadedFilePath.substring(0, downloadedFilePath.lastIndexOf('/'));
      await _showNotification("Download Complete",
          "The video has been downloaded successfully.", directoryPath);

      _log("Starting video segment extraction");
      await ffmpegService
          .extractVideoSegment(
              '00:00:10', '00:00:30'.toString().split('.').first)
          .catchError((e) {
        _log("Video segment extraction error: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Video segment extraction error: $e"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
      _log("Video segment extraction completed");

      setState(() {
        _progress = 1.0; // 추출 완료 후 진행률 100% 설정
        _isExtracting = false;
      });

      await _showNotification("Extraction Complete",
          "The video segment has been extracted successfully.", directoryPath);
    } else {
      _log("Time validation failed");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InvalidTimeRangeDialog(context);
        },
      );
    }
  }

  void _log(String message) {
    setState(() {
      _logs.add(message);
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181B), // 배경색 설정
      appBar: WelcomeAppBar(title: '환영해요!'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExtractInstructionText(),
            const SizedBox(height: 16),
            YouTubeUrlInput(urlController: _urlController),
            const SizedBox(height: 16),
            TimeSegmentToggle(
              isSegmentEnabled: _isSegmentEnabled,
              onToggle: _toggleSegment,
            ),
            TimeIntervalSelector(
              isSegmentEnabled: _isSegmentEnabled,
              startTimeControllers: _startTimeControllers,
              endTimeControllers: _endTimeControllers,
            ),
            const SizedBox(height: 16),
            FormatDropdown(
              audioFormats: audioFormats,
              videoFormats: videoFormats,
              onChanged: (String? value) {},
            ),
            const SizedBox(height: 16),
            (_isExtracting)
                ? ExtractProgressIndicator(progress: _progress)
                : ExtractButton(onPressed: () async {
                    await _downloadVideo();
                  }),
          ],
        ),
      ),
    );
  }
}
