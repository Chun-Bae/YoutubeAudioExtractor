import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VideoService {
  Future<void> downloadYouTubeVideo(String videoUrl) async {
    print('Starting video download');
    
    var yt = YoutubeExplode();
    print('YouTube Explode initialized');

    var video = await yt.videos.get(videoUrl);
    print('Video info fetched: ${video.title}');

    var manifest = await yt.videos.streamsClient.getManifest(video.id);
    var streamInfo = manifest.muxed.withHighestBitrate();
    print('Stream info fetched');

    var stream = yt.videos.streamsClient.get(streamInfo);

    // 앱에서 접근 가능한 디렉터리 경로 가져오기
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var filePath = '$appDocPath/downloaded_video.mp4';
    print('File path: $filePath');

    var file = File(filePath);
    var output = file.openWrite();
    await stream.pipe(output);
    await output.flush();
    await output.close();
    yt.close();
    print('Video download complete');
  }
}
