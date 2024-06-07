import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FFmpegService {
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  Future<void> extractVideoSegment(String startTime, String duration) async {
    print('Starting video segment extraction');

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String inputFilePath = '$appDocPath/downloaded_video.mp4';
    String outputFilePath = '$appDocPath/extracted_segment.mp4';
    print('Input file path: $inputFilePath');
    print('Output file path: $outputFilePath');

    String ffmpegCommand = '-i $inputFilePath -ss $startTime -t $duration -c copy $outputFilePath';
    print('FFmpeg command: $ffmpegCommand');

    await _flutterFFmpeg.execute(ffmpegCommand).then((rc) => print("FFmpeg process exited with rc $rc"));
    print('Video segment extraction complete');
  }
}
