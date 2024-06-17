import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'directory_service.dart';

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

  Future<void> showExtractionCompleteNotification({
    required String downloadedFilePath,
    required String fileNameWithformat,
    required bool cancelExtract,
  }) async {
    if (cancelExtract) return;

    final directoryPath =
        downloadedFilePath.substring(0, downloadedFilePath.lastIndexOf('/'));
    await showNotification(
        "Extraction Complete", "$fileNameWithformat 다운로드 완료!", directoryPath);
  }
}
