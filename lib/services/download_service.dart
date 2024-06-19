import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_audio_extractor/services/time_duration_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'ffmpeg_service.dart';
import '../providers/extract_text_editing_provider.dart';
import '../providers/download_provider.dart';
import '../providers/log_provider.dart';
import '../providers/extraction_provider.dart';

class DownloadService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FFmpegService _ffmpegService = FFmpegService();
  late String _title;
  String? _downloadedFilePath;

  static bool isCancelled = false;

  // title
  String get title => _title;
  set title(String value) {
    _title = value;
  }

  // downloadedFilePath
  String? get downloadedFilePath => _downloadedFilePath;
  set downloadedFilePath(String? value) {
    _downloadedFilePath = value;
  }

  DownloadService(this.flutterLocalNotificationsPlugin);

  Future<Duration> getYouTubeVideoDuration(String videoUrl) async {
    var yt = YoutubeExplode();
    var video = await yt.videos.get(videoUrl);
    yt.close();
    return video.duration ?? Duration.zero;
  }

  Future<void> downloadYouTubeVideo({
    required String url,
    required Function(double) onProgress,
    required Function(String) log,
  }) async {
    log("Starting video download");
    var yt = YoutubeExplode();

    log("YouTube Explode initialized");
    var video = await yt.videos.get(url);
    title = video.title;

    log("Video info fetched: ${video.title}");
    var manifest = await yt.videos.streamsClient.getManifest(video.id);
    var streamInfo = manifest.muxed.withHighestBitrate();

    log("Stream info fetched");
    var stream = yt.videos.streamsClient.get(streamInfo);
    Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      throw Exception("Could not get the external storage directory");
    }

    String externalPath = '${externalDir.path}';
    downloadedFilePath = '$externalPath/downloaded_video.mp4';
    log("File path: $downloadedFilePath");

    var file = File(downloadedFilePath!);
    var output = file.openWrite();

    // Download the video with progress
    var totalBytes = streamInfo.size.totalBytes;
    var downloadedBytes = 0;

    onProgress(0.0);

    await for (var data in stream) {
      if (isCancelled) {
        isCancelled = false;
        log("Download cancelled");
        _ffmpegService.dispose();
        await output.close();
        await file.delete();
        yt.close();
        throw ArgumentError("Download cancelled");
      }

      downloadedBytes += data.length;
      onProgress(downloadedBytes / totalBytes);
      output.add(data);
    }

    onProgress(1.0);

    await output.flush();
    await output.close();
    yt.close();
    log("Video download complete");
  }

  Future<void> startVideoDownload(BuildContext context) async {
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    final downloadProvider =
        Provider.of<DownloadProvider>(context, listen: false);
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    if (extractText.format == '') {
      throw ArgumentError('format');
    }

    logProvider.writeLog("Starting video download");

    await downloadYouTubeVideo(
      url: extractText.url,
      onProgress: (progress) => downloadProvider.downloadProgress = progress,
      log: logProvider.writeLog,
    );

    extractText.videoTitle = title;
    extractText.downloadedPath = downloadedFilePath!;
    logProvider.writeLog("Video download completed");
  }

  Future<void> deleteOriginalVideo(BuildContext context) async {
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    var file = File(downloadedFilePath!);
    if (await file.exists()) {
      await file.delete();
      logProvider.writeLog('Original video file deleted: $downloadedFilePath');
    } else {
      logProvider.writeLog('Original video file not found for deletion');
    }
  }

  Future<void> startVideoExtraction(BuildContext context) async {
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    final extractionProvider =
        Provider.of<ExtractionProvider>(context, listen: false);
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    if (extractText.fileName.isEmpty) {
      extractText.fileName = "extract_file";
    }
    extractText.fileNameWithformat =
        "${extractText.fileName}.${extractText.format.toLowerCase()}";
    extractText.durationTime = TimeDurationService().StartTimeIntervalEndTime(
      startControllers: extractText.startTimeControllers,
      endControllers: extractText.endTimeControllers,
    );

    logProvider.writeLog("Starting video segment extraction");
    await extractVideoSegment(
      startTime: extractText.startTime,
      duration: extractText.durationTime,
      inputFilePath: extractText.downloadedPath,
      outputFileWithFormatName: extractText.fileNameWithformat,
      formatCommand: extractText.format,
      log: logProvider.writeLog,
      onProgress: (progress) => extractionProvider.extractProgress = progress,
    );
    logProvider.writeLog("Video segment extraction completed");
  }

  Future<void> extractVideoSegment({
    required String startTime,
    required String duration,
    required String inputFilePath,
    required String outputFileWithFormatName,
    required String formatCommand,
    required Function(String) log,
    required Function(double)? onProgress,
  }) async {
    await _ffmpegService.extractVideoSegment(
      startTime: startTime,
      duration: duration,
      inputFilePath: inputFilePath,
      outputFileWithFormatName: outputFileWithFormatName,
      formatCommand: formatCommand,
      log: log,
      onProgress: onProgress,
    );
    log("Video segment extraction complete");
  }

  static void cancelDownload() {
    isCancelled = true;
  }

  static void cancelInitDownload() {
    isCancelled = false;
  }

  void dispose() {
    _ffmpegService.dispose();
  }
}
