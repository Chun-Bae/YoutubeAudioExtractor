import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:io';
import '../app/utils/ffmpeg_utils.dart';

class FFmpegService {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  final FlutterFFmpegConfig _flutterFFmpegConfig = FlutterFFmpegConfig();

  FFmpegService() {
    _flutterFFmpegConfig.enableStatisticsCallback((statistics) {
      _progressCallback?.call(statistics.time, statistics.size);
    });
  }

  Function(int time, int size)? _progressCallback;

  Future<void> extractVideoSegment(
      String startTime,
      String duration,
      String inputFilePath,
      String outputFilePath,
      String formatCommand,
      Function(String) log,
      Function(double)? onProgress) async {
    log('Starting video segment extraction');
    log('Input file path: $inputFilePath');

    Directory externalDir = Directory('/storage/emulated/0/Documents');
    String allOutputFilePath = '${externalDir.path}$outputFilePath';
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
    int durationInSeconds = _parseDuration(duration);

    _progressCallback = (int time, int size) {
      onProgress!(0.0);
      if (onProgress != null && durationInSeconds > 0) {
        double progress = time / (durationInSeconds * 1000); // ms to s
        onProgress(progress);
      }
    };

    await _flutterFFmpeg
        .execute(ffmpegCommand)
        .then((rc) => log("FFmpeg process exited with rc $rc"));
    log('Video segment extraction complete');

    _progressCallback = null;
  }

  int _parseDuration(String duration) {
    List<String> parts = duration.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return hours * 3600 + minutes * 60 + seconds;
  }
}
