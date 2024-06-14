final formatCommands = {
  'mp4': '-c:v libx264 -c:a aac',
  'avi': '-c:v libx264 -c:a libmp3lame',
  'mkv': '-c:v libx264 -c:a aac',
  'mov': '-c:v libx264 -c:a aac',
  'flv': '-c:v libx264 -c:a libmp3lame',
  'wmv': '-c:v wmv2 -c:a wmav2',
  'mpeg': '-c:v mpeg2video -c:a mp2',
  'webm': '-c:v libvpx -c:a libvorbis',
  'ogv': '-c:v libtheora -c:a libvorbis',
  'ts': '-c:v libx264 -c:a aac -bsf:v h264_mp4toannexb',
  'mp3': '-b:a 192K',
  'wav': '-b:a 192k',
  'flac': '-b:a 192k',
  'aac': '-b:a 192k',
  'wma': '-b:a 192k',
  'ogg': '-b:a 192k',
  'm4a': '-b:a 192k',
  'amr': '-vn -ar 8000 -ac 1 -b:a 12.2k',
  'aiff': '-b:a 192k',
  'au': '-b:a 192k',
};

String generateFFmpegCommand({
  required String inputFilePath,
  required String startTime,
  required String duration,
  required String format,
  required String outputFilePath,
}) {
  final formatCommand = formatCommands[format.toLowerCase()];
  if (formatCommand == null) {
    throw ArgumentError('Unsupported format: $format');
  }
  late String command;

  command =
      '-y -i $inputFilePath -ss $startTime -t $duration $formatCommand $outputFilePath';

  return command;
}
