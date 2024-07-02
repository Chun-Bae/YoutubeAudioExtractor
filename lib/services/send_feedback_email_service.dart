import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../app/widgets/Dialog/SendFeedbackEmailErrorDialog.dart';

class SendFeedbackEmailService {
  @override
  Future<Map<String, dynamic>> _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return {
      "App Name": packageInfo.appName,
      "Package Name": packageInfo.packageName,
      "Version": packageInfo.version,
      "Build Number": packageInfo.buildNumber,
    };
  }

  Future<Map<String, dynamic>> getDeviceInfo(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData;

    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData = {
        "Device": androidInfo.model,
        "Android Version": androidInfo.version.release,
        "SDK": androidInfo.version.sdkInt,
      };
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData = {
        "Device": iosInfo.utsname.machine,
        "iOS Version": iosInfo.systemVersion,
      };
    } else {
      deviceData = {
        "Platform": "Unknown",
      };
    }

    return deviceData;
  }

  Future<String> getEmailBody(BuildContext context) async {
    Map<String, dynamic> appInfo = await _getAppInfo();
    Map<String, dynamic> deviceInfo = await getDeviceInfo(context);

    String body = "";

    body += "==============\n";

    appInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    deviceInfo.forEach((key, value) {
      body += "$key: $value\n";
    });

    body += "==============\n";

    return body;
  }

  Future<void> sendFeedbackEmail(BuildContext context) async {
    String body = await getEmailBody(context);
    const String sendFeedbackEmailErrorText =
        '이메일 클라이언트를 찾을 수 없습니다. 이메일 클라이언트가 설치되어 있는지 확인해주세요.\n\n기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드리겠습니다.  :)\n\ndbtjrdla2056@gmail.com';
    final Email email = Email(
      body: body,
      subject: '[유튜브 추출기 앱 문의]',
      recipients: ['dbtjrdla2056@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      // throw 'Error';
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Error: $error');
      sendFeedbackEmailErrorDialog(context, sendFeedbackEmailErrorText);
    }
  }
}
