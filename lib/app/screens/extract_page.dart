import '../widgets/AppBar/WelcomeAppBar.dart';
import '../widgets/TextField/TimeIntervalSelector.dart';
import '../widgets/TextField/YouTubeUrlInput.dart';
import '../widgets/TextField/FileNameInput.dart';
import '../widgets/TextField/ExtractInstructionText.dart';
import '../widgets/TextField/CancelText.dart';
import '../widgets/Button/ExtractButton.dart';
import '../widgets/Button/ExtractCancelButton.dart';
import '../widgets/Dropdown/FormatDropdown.dart';
import '../widgets/Indicator/ExtractProgressIndicator.dart';
import '../widgets/Indicator/GettingVideoTimeIndicator.dart';
import '../widgets/Dialog/InvalidTimeRangeDialog.dart';
import '../widgets/Dialog/ExtractErrorDialog.dart';
import '../widgets/Toggle/TimeSegmentToggle.dart';
import '../widgets/Snackbar/GetTimeSnackbar.dart';
import '../../services/time_validation_service.dart';
import '../../services/time_duration_service.dart';
import '../../services/download_service.dart';
import '../../services/ffmpeg_service.dart';
import '../../services/notification_service.dart';
import '../../services/permission_service.dart';
import '../../services/url_validation_service.dart';
import '../../models/formatter.dart';
import '../../models/extract_status.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class ExtractPage extends StatefulWidget {
  @override
  _ExtractPageState createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> {
  TextEditingController _urlController = TextEditingController();
  TextEditingController _fileNameController = TextEditingController();
  TextEditingController _downloadedFilePathController = TextEditingController();

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
  bool _isGettingVideoTime = false;
  bool _cancelExtract = false;
  bool _isAnimating = false;
  List<String> _logs = [];

  String? _selectedFormat;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NotificationService notificationService;
  late DownloadService downloadService;
  late String downloadedFilePath;

  Duration _videoDuration = Duration.zero; // 전체 동영상 길이 상태
  final ScrollController _scrollController = ScrollController();

  int _extractStatus = EXTRACT_STATUS_IDLE;
  double _download_process = 0.0;
  double _extract_process = 0.0;

  @override
  void initState() {
    super.initState();
    PermissionService.requestStoragePermission(_log);
    _initializeServices();
  }

  void _initializeServices() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    notificationService = NotificationService(flutterLocalNotificationsPlugin);
    downloadService = DownloadService(flutterLocalNotificationsPlugin);
    await notificationService.initialize(_log);
  }

  void _toggleSegment(bool value) {
    setState(() {
      _isSegmentEnabled = value;
    });
  }

  Future<void> _validateAndDownloadVideo() async {
    setState(() {
      _isAnimating = true;
    });
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
    setState(() {
      _isAnimating = false;
    });
  }

  Future<void> _downloadVideo() async {
    setState(() {
      _extractStatus = EXTRACT_STATUS_EXTRACTING;
      _download_process = 0.0;
    });
    try {
      await _startVideoDownload(downloadService);
      await _startVideoExtraction(downloadService);
      await _deleteOriginalVideo(downloadService);
      await _showExtractionCompleteNotification(downloadService);
      await Future.delayed(Duration(milliseconds: 100));
      if (_cancelExtract) {
        return;
      }
      setState(() {
        _extractStatus = EXTRACT_STATUS_COMPLETED;
        _download_process = 0.0;
        _extract_process = 0.0;
      });
    } catch (e) {
      _handleError(e);
    } finally {
      if (_cancelExtract) {
        return;
      }
      if (_extractStatus != EXTRACT_STATUS_COMPLETED) {
        setState(() {
          _extractStatus = EXTRACT_STATUS_IDLE;
        });
      }
    }
  }

  void _cancelExtraction() {
    _cancelExtract = true;
    setState(() {
      _extractStatus = EXTRACT_STATUS_CANCEL;
    });
    DownloadService.cancelDownload();
    FFmpegService.cancelExtraction();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _extractStatus = EXTRACT_STATUS_IDLE;
        _download_process = 0.0;
        _extract_process = 0.0;
        _cancelExtract = false;
      });
    });
  }

  Future<void> _startVideoDownload(DownloadService downloadService) async {
    if (_cancelExtract) return;
    if (_selectedFormat == null) {
      _handleError('포맷을 지정해주세요!');
      return;
    }

    _log("Starting video download");
    await downloadService.downloadYouTubeVideo(_urlController.text, (progress) {
      setState(() {
        _download_process = progress;
      });
    }, _log);
    _log("Video download completed");

    setState(() {
      downloadedFilePath = downloadService.downloadedFilePath;
      _downloadedFilePathController.text = downloadedFilePath;
    });
  }

  Future<void> _startVideoExtraction(DownloadService downloadService) async {
    if (_cancelExtract) return;

    late String startTime;
    late String duration;
    late String outputFilePath;
    _log("Starting video segment extraction");
    startTime =
        '${_startTimeControllers[0].text}:${_startTimeControllers[1].text}:${_startTimeControllers[2].text}';
    duration = '${TimeDurationService().isStartTimeBeforeEndTime(
      startControllers: _startTimeControllers,
      endControllers: _endTimeControllers,
    )}';
    setState(() {
      _extract_process = 0.0;
    });
    if (_fileNameController.text.isEmpty) {
      outputFilePath = '/extract_file.${_selectedFormat!.toLowerCase()}';
    } else {
      outputFilePath =
          '/${_fileNameController.text}.${_selectedFormat!.toLowerCase()}';
    }
    await downloadService.extractVideoSegment(startTime, duration,
        downloadedFilePath, outputFilePath, _selectedFormat!, _log, (progress) {
      setState(() {
        _extract_process = progress;
      });
    });
    _log("Video segment extraction completed");

    setState(() {
      _extract_process = 1.0;
    });
  }

  Future<void> _deleteOriginalVideo(DownloadService downloadService) async {
    _log("Deleting original video file");
    await downloadService.deleteOriginalVideo(_log);
  }

  Future<void> _showExtractionCompleteNotification(
      DownloadService downloadService) async {
    if (_cancelExtract) return;
    late String fileName;
    if (_fileNameController.text.isEmpty) {
      fileName = 'extract_file';
    } else {
      fileName = _fileNameController.text;
    }
    final directoryPath =
        downloadedFilePath.substring(0, downloadedFilePath.lastIndexOf('/'));
    await downloadService.showNotification(
        directoryPath, "${fileName}.${_selectedFormat!.toLowerCase()}");
  }

  void _handleError(dynamic error) {
    _log("Error: $error, type: ${error.runtimeType}");
    if (error is TypeError) {
      return;
    }
    String errorMessage;
    if (error is ArgumentError) {
      errorMessage = "URL을 잘못 입력하셨습니다.\nYouTube 주소를 확인해주세요.";
    } else if (error is PathNotFoundException) {
      errorMessage = "천천히 눌러 주세요!";
    } else if (error is Exception) {
      errorMessage = "알 수 없는 에러가 발생했습니다!";
    } else {
      // errorMessage = "알 수 없는 에러가 발생했습니다!";
      errorMessage = error.toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExtractErrorDialog(context, errorMessage);
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

  void _reset() {
    setState(() {
      _extractStatus = EXTRACT_STATUS_IDLE;
      _download_process = 0.0;
      _downloadedFilePathController.clear();
    });
  }

  Future<void> _getVideoDuration(String url) async {
    Future.delayed(Duration(milliseconds: 400));
    _urlController.text = removeSiParameter(url);
    try {
      setState(() {
        _isGettingVideoTime = true;
      });
      Duration duration = await downloadService.getYouTubeVideoDuration(url);
      setState(() {
        _videoDuration = duration;
      });
      _log('Video duration: ${_videoDuration.inSeconds} seconds');
      TimeDurationService().setEndTimeControllers(
        controllers: _endTimeControllers,
        totalSeconds: _videoDuration.inSeconds,
      );
      GetTimeSnackbar(context: context, message: "동영상 시간을 가져왔어요!").show();
    } catch (e) {
      _log('Failed to get video duration: $e');
    } finally {
      setState(() {
        _isGettingVideoTime = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14181B),
      appBar: WelcomeAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExtractInstructionText(),
                    const SizedBox(height: 16),
                    YouTubeUrlInput(
                      urlController: _urlController,
                      onChangeFunc: (url) async {
                        await _getVideoDuration(url);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        TimeSegmentToggle(
                          isSegmentEnabled: _isSegmentEnabled,
                          onToggle: _toggleSegment,
                        ),
                        SizedBox(width: 16),
                        if (_isGettingVideoTime) GettingVideoTimeIndicator(),
                      ],
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
                      onChanged: (String? value) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    FileNameInput(fileNameController: _fileNameController),
                    const SizedBox(height: 16),
                    RepaintBoundary(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        child: _extractStatus == EXTRACT_STATUS_EXTRACTING
                            ? Column(
                                children: <Widget>[
                                  ExtractProgressIndicator(
                                      progress: _download_process),
                                  ExtractProgressIndicator(
                                      progress: _extract_process),
                                  SizedBox(width: 10),
                                  ExtractCancelButton(
                                    onPressed: _cancelExtraction,
                                  ),
                                ],
                              )
                            : _extractStatus == EXTRACT_STATUS_CANCEL
                                ? const CancelText()
                                : ExtractButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isAnimating = true;
                                      });
                                      await _validateAndDownloadVideo();
                                      setState(() {
                                        _isAnimating = false;
                                      });
                                    },
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
