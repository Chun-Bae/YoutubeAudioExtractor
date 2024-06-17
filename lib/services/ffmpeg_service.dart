import 'dart:io';
import '../app/utils/ffmpeg_utils.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class FFmpegService {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  final FlutterFFmpegConfig _flutterFFmpegConfig = FlutterFFmpegConfig();
  static bool isCancelled = false;

  FFmpegService() {
    _flutterFFmpegConfig.enableStatisticsCallback((statistics) {
      _progressCallback?.call(statistics.time, statistics.size);
    });
  }

  void dispose() {
    _flutterFFmpeg.cancel();
    _progressCallback = null;
  }

  Function(int time, int size)? _progressCallback;

  Future<void> extractVideoSegment({
    required String startTime,
    required String duration,
    required String inputFilePath,
    required String outputFileWithFormatName,
    required String formatCommand,
    required Function(String) log,
    required Function(double)? onProgress,
  }) async {
    try {
      log('Starting video segment extraction');
      log('Input file path: $inputFilePath');

      Directory externalDir = Directory('/storage/emulated/0/Documents');
      String allOutputFilePath =
          '${externalDir.path}/$outputFileWithFormatName';
      log('Output file path: $allOutputFilePath');

      // 이미 존재하는 출력 파일 삭제
      var outputFile = File(allOutputFilePath);
      if (await outputFile.exists()) {
        await outputFile.delete();
      }

      String ffmpegCommand = generateFFmpegCommand(
        inputFilePath: inputFilePath,
        startTime: startTime,
        duration: duration,
        format: formatCommand,
        outputFilePath: allOutputFilePath,
      );
      log('FFmpeg command: $ffmpegCommand');

      // 추출할 비디오 세그먼트의 길이를 초 단위로 변환
      int durationInSeconds = await _parseDuration(duration);
      _progressCallback = (int time, int size) {
        if (onProgress != null && durationInSeconds > 0) {
          double progress = time / (durationInSeconds * 1000.0); // ms to s
          if (progress < 0.99) onProgress(progress);
          if (isCancelled) {
            _flutterFFmpeg.cancel();
            _progressCallback = null;
            isCancelled = false;
            throw ArgumentError("Download cancelled");
          }
        }
      };
      if (onProgress != null) {
        onProgress(0.0);
      }
      await _flutterFFmpeg
          .execute(ffmpegCommand)
          .then((rc) => log("FFmpeg process exited with rc $rc"));
      log('Video segment extraction complete');
      if (onProgress != null) {
        onProgress(1.0);
      }

      _progressCallback = null;
    } finally {
      dispose();
    }
  }

  Future<int> _parseDuration(String duration) async {
    if (duration.isEmpty) {
      return 0;
    }
    List<String> parts = duration.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return hours * 3600 + minutes * 60 + seconds;
  }

  static void cancelExtraction() {
    isCancelled = true;
  }
}
