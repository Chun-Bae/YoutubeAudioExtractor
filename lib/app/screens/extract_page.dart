import 'package:youtube_audio_extractor/providers/download_provider.dart';

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
  bool _isAnimating = false;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late NotificationService notificationService;
  late DownloadService downloadService;
  late VideoDurationService videoDurationService;

  int _extractStatus = EXTRACT_STATUS_IDLE;

  @override
  void initState() {
    super.initState();
    _initializeServices(context);
  }

  void _initializeServices(BuildContext context) async {
    final logProvider = Provider.of<LogProvider>(context, listen: false);

    PermissionService.requestStoragePermission(logProvider.writeLog);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    notificationService = NotificationService(flutterLocalNotificationsPlugin);
    downloadService = DownloadService(flutterLocalNotificationsPlugin);
    videoDurationService =
        VideoDurationService(downloadService: downloadService);
    await notificationService.initialize(logProvider.writeLog);
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
      logProvider.writeLog("Time validation passed");
      await _downloadVideo(context);
    } else {
      logProvider.writeLog("Time validation failed");
      _showInvalidTimeRangeDialog();
    }
    setState(() {
      _isAnimating = false;
    });
  }

  Future<void> _downloadVideo(BuildContext context) async {
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    final downloadProvider =
        Provider.of<DownloadProvider>(context, listen: false);
    final extractionProvider =
        Provider.of<ExtractionProvider>(context, listen: false);
    final logProvider = Provider.of<LogProvider>(context, listen: false);

    try {
      setState(() {
        _extractStatus = EXTRACT_STATUS_EXTRACTING;
      });
      await downloadService.startVideoDownload(context);
      await downloadService.startVideoExtraction(context);
      await downloadService.deleteOriginalVideo(context);
      await notificationService.showExtractionCompleteNotification(context);
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        _extractStatus = EXTRACT_STATUS_COMPLETED;
      });
    } catch (e) {
      logProvider.handleError(context, e);
    } finally {
      if (extractionProvider.cancelExtract) {
        return;
      }
      extractionProvider.cancelExtract = false;
      downloadProvider.downloadProgress = 0.0;
      extractionProvider.extractProgress = 0.0;
      extractText.downloadedPathController.clear();
      if (_extractStatus != EXTRACT_STATUS_COMPLETED) {
        setState(() {
          _extractStatus = EXTRACT_STATUS_IDLE;
        });
      }
    }
  }

  void _cancelExtraction(BuildContext context) {
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    final downloadProvider =
        Provider.of<DownloadProvider>(context, listen: false);
    final extractionProvider =
        Provider.of<ExtractionProvider>(context, listen: false);

    extractionProvider.cancelExtract = true;
    setState(() {
      _extractStatus = EXTRACT_STATUS_CANCEL;
    });
    DownloadService.cancelDownload();
    FFmpegService.cancelExtraction();
    Future.delayed(Duration(seconds: 3), () {
      downloadProvider.downloadProgress = 0.0;
      extractionProvider.extractProgress = 0.0;
      extractionProvider.cancelExtract = false;
      extractText.downloadedPathController.clear();
      setState(() {
        _extractStatus = EXTRACT_STATUS_IDLE;
      });
    });
  }

  void _showInvalidTimeRangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InvalidTimeRangeDialog(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    final downloadProvider =
        Provider.of<DownloadProvider>(context, listen: false);
    final extractionProvider =
        Provider.of<ExtractionProvider>(context, listen: false);

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
                        extractText.format = value!;
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
                                  Consumer<DownloadProvider>(
                                    builder: (context, extraction, child) {
                                      return ExtractProgressIndicator(
                                          progress: downloadProvider
                                              .downloadProgress);
                                    },
                                  ),
                                  Consumer<ExtractionProvider>(
                                    builder: (context, extraction, child) {
                                      return ExtractProgressIndicator(
                                          progress: extractionProvider
                                              .extractProgress);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  ExtractCancelButton(
                                    onPressed: () => _cancelExtraction(context),
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
