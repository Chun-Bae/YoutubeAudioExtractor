import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'download_service.dart';
import 'time_duration_service.dart';
import 'url_validation_service.dart';
import '../app/widgets/Snackbar/GetTimeSnackbar.dart';
import '../providers/extract_text_editing_provider.dart';
import '../providers/extraction_provider.dart';

class VideoDurationService {
  final DownloadService downloadService;

  VideoDurationService({required this.downloadService});

  Future<void> getVideoDuration(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1000));
    final extract_text =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    final extraction = Provider.of<ExtractionProvider>(context, listen: false);

    extract_text.url = removeSiParameter(extract_text.url);

    try {
      extraction.isGettingVideoTime = true;
      Duration duration =
          await downloadService.getYouTubeVideoDuration(extract_text.url);
      extract_text.durationTime = duration.inSeconds.toString();

      _log('Video duration: ${extract_text.durationTime} seconds');
      TimeDurationService().setEndTimeControllers(
        controllers: extract_text.endTimeControllers,
        totalSeconds: duration.inSeconds,
      );
      GetTimeSnackbar(context: context, message: "동영상 시간을 가져왔어요!").show();
    } catch (e) {
      _log('Failed to get video duration: $e');
    } finally {
      extraction.isGettingVideoTime = false;
    }
  }

  void _log(String message) {
    print(message);
  }
}
