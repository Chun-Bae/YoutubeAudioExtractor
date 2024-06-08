import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestStoragePermission(Function(String) logCallback) async {
    if (await Permission.storage.request().isGranted) {
      logCallback('Storage permission granted.');
    } else {
      logCallback('Storage permission denied.');
    }
  }
}
