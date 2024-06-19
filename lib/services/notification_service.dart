import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:youtube_audio_extractor/providers/download_provider.dart';
import 'package:youtube_audio_extractor/providers/extraction_provider.dart';
import 'directory_service.dart';
import '../providers/extract_text_editing_provider.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService(this.flutterLocalNotificationsPlugin);

  Future<void> initialize(void Function(String) logCallback) async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      if (notificationResponse.payload != null) {
        await DirectoryService.openDownloadDirectory(logCallback);
      }
    });
  }

  Future<void> showExtractionCompleteNotification(BuildContext context) async {
    final extractText =
        Provider.of<ExtractTextEditingProvider>(context, listen: false);
    final extractionProvider =
        Provider.of<ExtractionProvider>(context, listen: false);
    if (extractionProvider.cancelExtract)
      throw ArgumentError("Download cancelled");
    ;

    final directoryPath = extractText.downloadedPath
        .substring(0, extractText.downloadedPath.lastIndexOf('/'));
    await showNotification("${extractText.videoTitle}",
        "${extractText.fileNameWithformat} 다운로드 완료!", directoryPath);
  }

  Future<void> showNotification(
      String title, String body, String directoryPath) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'youtube_extract_channel', 'YoutubeExtract',
        channelDescription: 'Notification channel for downloads',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: directoryPath);
  }
}
