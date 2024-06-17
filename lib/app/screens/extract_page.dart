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
import '../widgets/Toggle/TimeSegmentToggle.dart';
import '../../services/time_validation_service.dart';
import '../../services/time_duration_service.dart';
import '../../services/download_service.dart';
import '../../services/ffmpeg_service.dart';
import '../../services/notification_service.dart';
import '../../services/permission_service.dart';
import '../../services/video_duration_service.dart';
import '../../models/formatter.dart';
import '../../models/extract_status.dart';
import '../../providers/extract_text_editing_provider.dart';
import '../../providers/extraction_provider.dart';
import '../../providers/log_provider.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class ExtractPage extends StatefulWidget {
  @override
  _ExtractPageState createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> {

  bool _isSegmentEnabled = false;
  bool _cancelExtract = false;
  bool _isAnimating = false;

  String? _selectedFormat;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NotificationService notificationService;
  late DownloadService downloadService;
  late VideoDurationService videoDurationService;
  late String downloadedFilePath;

  int _extractStatus = EXTRACT_STATUS_IDLE;
  double _download_process = 0.0;
  double _extract_process = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeServices(context);
  }

  void _initializeServices(BuildContext context) async {
    final logProvider = Provider.of<LogProvider>(context, listen: false);

    PermissionService.requestStoragePermission(logProvider.log);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    notificationService = NotificationService(flutterLocalNotificationsPlugin);
    downloadService = DownloadService(flutterLocalNotificationsPlugin);
    videoDurationService =
        VideoDurationService(downloadService: downloadService);
    await notificationService.initialize(logProvider.log);
  }

  void _toggleSegment(bool value) {
    setState(() {
      _isSegmentEnabled = value;
    });
  }

  Future<void> _validateAndDownloadVideo(BuildContext context) async {
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);

    setState(() {
      _isAnimating = true;
    });
    if (TimeValidationService().isStartTimeBeforeEndTime(
      startControllers: extractText.startTimeControllers,
      endControllers: extractText.endTimeControllers,
    )) {
      logProvider.log("Time validation passed");
      await _downloadVideo(context);
    } else {
      logProvider.log("Time validation failed");
      _showInvalidTimeRangeDialog();
    }
    setState(() {
      _isAnimating = false;
    });
  }

  Future<void> _downloadVideo(BuildContext context) async {
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    final extraction = Provider.of<ExtractionProvider>(context, listen: false);
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    setState(() {
      _extractStatus = EXTRACT_STATUS_EXTRACTING;
      _download_process = 0.0;
    });
    try {
      await _startVideoDownload(context, downloadService);
      await _startVideoExtraction(context, downloadService);
      await _deleteOriginalVideo(context, downloadService);
      await notificationService.showExtractionCompleteNotification(
        downloadedFilePath: downloadedFilePath,
        fileNameWithformat: extractText.fileNameWithformat,
        cancelExtract: extraction.cancelExtract,
      );
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
      logProvider.handleError(context, e);
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

  Future<void> _startVideoDownload(
    BuildContext context,
    DownloadService downloadService,
  ) async {
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    if (_cancelExtract) return;
    if (_selectedFormat == null) {
      logProvider.handleError(context, '포맷을 지정해주세요!');
      return;
    }

    logProvider.log("Starting video download");
    await downloadService.downloadYouTubeVideo(extractText.url, (progress) {
      setState(() {
        _download_process = progress;
      });
    }, logProvider.log);
    logProvider.log("Video download completed");

    setState(() {
      downloadedFilePath = downloadService.downloadedFilePath;
      extractText.downloadedPath = downloadedFilePath;
    });
  }

  Future<void> _startVideoExtraction(
    BuildContext context,
    DownloadService downloadService,
  ) async {
    if (_cancelExtract) return;
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);

    late String startTime;
    late String duration;
    late String outputFilePath;
    logProvider.log("Starting video segment extraction");
    startTime =
        '${extractText.startTimeControllers[0].text}:${extractText.startTimeControllers[1].text}:${extractText.startTimeControllers[2].text}';
    duration = '${TimeDurationService().isStartTimeBeforeEndTime(
      startControllers: extractText.startTimeControllers,
      endControllers: extractText.endTimeControllers,
    )}';
    setState(() {
      _extract_process = 0.0;
    });
    if (extractText.fileName.isEmpty) {
      outputFilePath = '/extract_file.${_selectedFormat!.toLowerCase()}';
    } else {
      outputFilePath =
          '/${extractText.fileName}.${_selectedFormat!.toLowerCase()}';
    }
    await downloadService.extractVideoSegment(
        startTime,
        duration,
        downloadedFilePath,
        outputFilePath,
        _selectedFormat!,
        logProvider.log, (progress) {
      setState(() {
        _extract_process = progress;
      });
    });
    logProvider.log("Video segment extraction completed");

    setState(() {
      _extract_process = 1.0;
    });
  }

  Future<void> _deleteOriginalVideo(
      BuildContext context, DownloadService downloadService) async {
    final logProvider = Provider.of<LogProvider>(context, listen: false);

    logProvider.log("Deleting original video file");
    await downloadService.deleteOriginalVideo(logProvider.log);
  }

  Future<void> _showExtractionCompleteNotification(
      DownloadService downloadService) async {
    if (_cancelExtract) return;
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    late String fileName;
    if (extractText.fileName.isEmpty) {
      fileName = 'extract_file';
    } else {
      fileName = extractText.fileName;
    }
    final directoryPath =
        downloadedFilePath.substring(0, downloadedFilePath.lastIndexOf('/'));
    await downloadService.showNotification(
        directoryPath, "${fileName}.${_selectedFormat!.toLowerCase()}");
  }

  void _showInvalidTimeRangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InvalidTimeRangeDialog(context);
      },
    );
  }

  void _reset() {
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);

    setState(() {
      _extractStatus = EXTRACT_STATUS_IDLE;
      _download_process = 0.0;
      extractText.downloadedPathController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);

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
                      urlController: extractText.urlController,
                      onChanged: (url) async {
                        await videoDurationService.getVideoDuration(context);
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
                        Consumer<ExtractionProvider>(
                          builder: (context, extraction, child) {
                            return extraction.isGettingVideoTime
                                ? GettingVideoTimeIndicator()
                                : Container();
                          },
                        ),
                      ],
                    ),
                    TimeIntervalSelector(
                      isSegmentEnabled: _isSegmentEnabled,
                      startTimeControllers: extractText.startTimeControllers,
                      endTimeControllers: extractText.endTimeControllers,
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
                    FileNameInput(
                        fileNameController: extractText.fileNameController),
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
                                      await _validateAndDownloadVideo(context);
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
