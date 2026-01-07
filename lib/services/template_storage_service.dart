import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TemplateStorageService {
  static const String _templateDirName = 'templates';

  static Future<Directory> getTemplateDirectory() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final templateDir = Directory('${baseDir.path}/$_templateDirName');

    if (!await templateDir.exists()) {
      await templateDir.create(recursive: true);
    }

    return templateDir;
  }

  static Future<File> getTemplateFile(String fileName) async {
    final dir = await getTemplateDirectory();
    return File('${dir.path}/$fileName');
  }

  static Future<bool> exists(String fileName) async {
    final file = await getTemplateFile(fileName);
    return file.exists();
  }

  static Future<void> delete(String fileName) async {
    final file = await getTemplateFile(fileName);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> clearAll() async {
    final dir = await getTemplateDirectory();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
