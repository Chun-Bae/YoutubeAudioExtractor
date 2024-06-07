import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VideoService {
  late String downloadedFilePath;

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

    Directory externalDir = Directory('/storage/emulated/0/Documents');

    if (externalDir == null) {
      throw Exception("Could not get the external storage directory");
    }
    String externalPath = '${externalDir.path}';
    downloadedFilePath = '$externalPath/downloaded_video.mp4';
    print('File path: $downloadedFilePath');

    var file = File(downloadedFilePath);
    var output = file.openWrite();
    await stream.pipe(output);
    await output.flush();
    await output.close();
    yt.close();
    print('Video download complete');
  }
}
