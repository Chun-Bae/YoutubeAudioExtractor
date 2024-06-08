import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:io';

class FFmpegService {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  Future<void> extractVideoSegment(String startTime, String duration,
      String inputFilePath, String outputFilePath, Function(String) log) async {
    log('Starting video segment extraction');
    log('Input file path: $inputFilePath');
    log('Output file path: $outputFilePath');

    // 이미 존재하는 출력 파일 삭제
    var outputFile = File(outputFilePath);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }

    String ffmpegCommand =
        '-y -i $inputFilePath -ss $startTime -t $duration -c copy $outputFilePath';
    log('FFmpeg command: $ffmpegCommand');

    await _flutterFFmpeg
        .execute(ffmpegCommand)
        .then((rc) => log("FFmpeg process exited with rc $rc"));
    log('Video segment extraction complete');
  }
}
