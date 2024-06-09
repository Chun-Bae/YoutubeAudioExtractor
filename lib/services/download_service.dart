import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';
import 'notification_service.dart';
import 'ffmpeg_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DownloadService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  DownloadService(this.flutterLocalNotificationsPlugin);

  late String downloadedFilePath;

  Future<void> downloadYouTubeVideo(String videoUrl,
      Function(double) onProgress, Function(String) log) async {
    log("Starting video download");

    var yt = YoutubeExplode();
    log("YouTube Explode initialized");

    var video = await yt.videos.get(videoUrl);
    log("Video info fetched: ${video.title}");

    var manifest = await yt.videos.streamsClient.getManifest(video.id);
    var streamInfo = manifest.muxed.withHighestBitrate();
    log("Stream info fetched");

    var stream = yt.videos.streamsClient.get(streamInfo);

    Directory externalDir = Directory('/storage/emulated/0/Documents');
    String externalPath = '${externalDir.path}';
    downloadedFilePath = '$externalPath/downloaded_video.mp4';
    log("File path: $downloadedFilePath");

    var file = File(downloadedFilePath);
    var output = file.openWrite();

    // Download the video with progress
    var totalBytes = streamInfo.size.totalBytes;
    var downloadedBytes = 0;

    await for (var data in stream) {
      downloadedBytes += data.length;
      onProgress(downloadedBytes / totalBytes);
      output.add(data);
    }

    await output.flush();
    await output.close();
    yt.close();
    log("Video download complete");
  }

  Future<void> extractVideoSegment(
      String startTime,
      String duration,
      String inputFilePath,
      String outputFilePath,
      String formatCommand,
      Function(String) log) async {
    var ffmpegService = FFmpegService();
    await ffmpegService.extractVideoSegment(
        startTime, duration, inputFilePath, outputFilePath, formatCommand, log);
    log("Video segment extraction complete");
  }

  Future<void> showNotification(
      String title, String body, String directoryPath) async {
    final notificationService =
        NotificationService(flutterLocalNotificationsPlugin);
    await notificationService.showNotification(title, body, directoryPath);
  }

  Future<void> deleteOriginalVideo(Function(String) log) async {
    var file = File(downloadedFilePath);
    if (await file.exists()) {
      await file.delete();
      log('Original video file deleted');
    } else {
      log('Original video file not found for deletion');
    }
  }
}
