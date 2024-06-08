import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class DirectoryService {
  static Future<void> openDownloadDirectory(Function(String) logCallback) async {
    try {
      Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        logCallback("Could not get the external storage directory");
        return;
      }

      String documentsPath = '${directory.path}/Documents';
      Directory documentsDirectory = Directory(documentsPath);

      if (await documentsDirectory.exists()) {
        logCallback('Directory exists: $documentsPath');
      } else {
        logCallback('Directory does not exist: $documentsPath');
        await documentsDirectory.create(recursive: true);
        logCallback('Directory created: $documentsPath');
      }

      // Use FilePicker to open the directory picker starting at the Documents directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        logCallback('Directory selected: $selectedDirectory');
      } else {
        logCallback('User canceled the picker');
      }
    } catch (e) {
      logCallback("Could not open directory: $e");
    }
  }
}
