import '../widgets/AppBar/WelcomeAppBar.dart';
import '../widgets/TextField/TimeIntervalSelector.dart';
import '../widgets/TextField/YouTubeUrlInput.dart';
import '../widgets/TextField/ExtractInstructionText.dart';
import '../widgets/Button/ExtractButton.dart';
import '../widgets/Dropdown/FormatDropdown.dart';
import '../widgets/Indicator/ExtractProgressIndicator.dart';
import '../widgets/Dialog/InvalidTimeRangeDialog.dart';
import '../widgets/Dialog/ExtractErrorDialog.dart';
import '../widgets/Toggle/TimeSegmentToggle.dart';
import '../../services/time_validation.dart';
import '../../services/download_service.dart';
import '../../services/notification_service.dart';
import '../../services/permission_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  List<String> _logs = [];

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NotificationService notificationService;
  late String downloadedFilePath;
  final ScrollController _scrollController = ScrollController();

  bool _isExtracting = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    PermissionService.requestStoragePermission(_log);
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    notificationService = NotificationService(flutterLocalNotificationsPlugin);
    await notificationService.initialize(_log);
  }

  void _toggleSegment(bool value) {
    setState(() {
      _isSegmentEnabled = value;
    });
  }

  Future<void> _showNotification(
      String title, String body, String directoryPath) async {
    final notificationService =
        NotificationService(flutterLocalNotificationsPlugin);
    await notificationService.showNotification(title, body, directoryPath);
  }

  Future<void> _validateAndDownloadVideo() async {
    if (TimeValidationService().isStartTimeBeforeEndTime(
      startControllers: _startTimeControllers,
      endControllers: _endTimeControllers,
    )) {
      _log("Time validation passed");
      await _downloadVideo();
    } else {
      _log("Time validation failed");
      _showInvalidTimeRangeDialog();
    }
  }

  Future<void> _downloadVideo() async {
    DownloadService downloadService =
        DownloadService(flutterLocalNotificationsPlugin);

    setState(() {
      _isExtracting = true;
      _progress = 0.0;
    });

    try {
      await _startVideoDownload(downloadService);
      await _startVideoExtraction(downloadService);
      await _deleteOriginalVideo(downloadService);
      await _showExtractionCompleteNotification(downloadService);
    } catch (e) {
      _handleError(e);
    } finally {
      setState(() {
        _isExtracting = false;
      });
    }
  }

  Future<void> _startVideoDownload(DownloadService downloadService) async {
    _log("Starting video download");
    await downloadService.downloadYouTubeVideo(_urlController.text, (progress) {
      setState(() {
        _progress = progress;
      });
    }, _log);
    _log("Video download completed");

    setState(() {
      downloadedFilePath = downloadService.downloadedFilePath;
      _downloadedFilePathController.text = downloadedFilePath;
      _progress = 0.5; // 다운로드 완료 후 중간 진행률 설정
    });
  }

  Future<void> _startVideoExtraction(DownloadService downloadService) async {
    _log("Starting video segment extraction");
    String startTime = '00:00:10';
    String duration = '00:00:30';
    String outputFilePath =
        '${downloadedFilePath.substring(0, downloadedFilePath.lastIndexOf('/'))}/extracted_segment.mp4';
    await downloadService.extractVideoSegment(
        startTime, duration, downloadedFilePath, outputFilePath, _log);
    _log("Video segment extraction completed");

    setState(() {
      _progress = 1.0; // 추출 완료 후 진행률 100% 설정
    });
  }

  Future<void> _deleteOriginalVideo(DownloadService downloadService) async {
    _log("Deleting original video file");
    await downloadService.deleteOriginalVideo(_log);
  }

  Future<void> _showExtractionCompleteNotification(
      DownloadService downloadService) async {
    final directoryPath =
        downloadedFilePath.substring(0, downloadedFilePath.lastIndexOf('/'));
    await _showNotification("Extraction Complete",
        "The video segment has been extracted successfully.", directoryPath);
  }

  void _handleError(dynamic error) {
    _log("Error: $error");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExtractErrorDialog(context, error.toString());
      },
    );
  }

  void _showInvalidTimeRangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InvalidTimeRangeDialog(context);
      },
    );
  }

  void _log(String message) {
    print(message);
    setState(() {
      _logs.add(message);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181B),
      appBar: WelcomeAppBar(),
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
                    await _validateAndDownloadVideo();
                  }),
          ],
        ),
      ),
    );
  }
}
