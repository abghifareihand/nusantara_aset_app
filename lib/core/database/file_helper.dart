import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<String> saveImageToAppDirectory(File imageFile, String folderName) async {
    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${dir.path}/images/$folderName');

    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    final fileName = path.basename(imageFile.path);
    final newImagePath = path.join(imageDir.path, fileName);
    final newImageFile = await imageFile.copy(newImagePath);
    return newImageFile.path;
  }

  static Future<Directory> getAppImageDirectory(String folderName) async {
    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${dir.path}/images/$folderName');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }
    return imageDir;
  }
}
