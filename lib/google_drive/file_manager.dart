import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class FileManager {
  static Future<String> get appDocumentsDir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<String> createGroupFolder(String groupName) async {
    final baseDir = await appDocumentsDir;
    final folderPath = path.join(baseDir, groupName);
    await Directory(folderPath).create(recursive: true);
    return folderPath;
  }

  static Future<List<FileSystemEntity>> getGroupFiles(String groupName) async {
    final folderPath = await createGroupFolder(groupName);
    return Directory(folderPath).list().toList();
  }

  static Future<File> saveFileToGroup(File file, String groupName, {String? customName}) async {
    final folderPath = await createGroupFolder(groupName);
    final fileName = customName ?? path.basename(file.path);
    final newPath = path.join(folderPath, fileName);
    return file.copy(newPath);
  }

  static Future<bool> fileExistsInGroup(String fileName, String groupName) async {
    final folderPath = await createGroupFolder(groupName);
    final filePath = path.join(folderPath, fileName);
    return File(filePath).exists();
  }
}