import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FFmpegService {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  Future<void> extractVideoSegment(String startTime, String duration) async {
    print('Starting video segment extraction');

    // 앱 전용의 외부 저장소 경로 설정
    Directory externalDir = Directory('/storage/emulated/0/Documents');

    if (externalDir == null) {
      throw Exception("Could not get the external storage directory");
    }
    String externalPath = '${externalDir.path}';
    var inputFilePath = '$externalPath/downloaded_video.mp4';
    var outputFilePath = '$externalPath/extracted_segment.mp4';
    print('Input file path: $inputFilePath');
    print('Output file path: $outputFilePath');

    // 이미 존재하는 출력 파일 삭제
    var outputFile = File(outputFilePath);
    if (await outputFile.exists()) {
      await outputFile.delete();
    }

    String ffmpegCommand =
        '-y -i $inputFilePath -ss $startTime -t $duration -c copy $outputFilePath';
    print('FFmpeg command: $ffmpegCommand');

    await _flutterFFmpeg
        .execute(ffmpegCommand)
        .then((rc) => print("FFmpeg process exited with rc $rc"));
    print('Video segment extraction complete');
  }
}
