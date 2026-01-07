import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';

import '../models/template_download_dto.dart';
import 'device_service.dart';
import 'local_storage_service.dart';

class TemplateDownloadService {
  // --------------------------------------------------------------------------
  // 📁 DOWNLOADS/Templates (PUBLIC STORAGE)
  // --------------------------------------------------------------------------
  Future<String> _downloadsDir() async {
    final dir = await getDownloadsDirectory();
    if (dir == null) {
      throw Exception('Downloads directory not available');
    }

    final templates = Directory('${dir.path}/Templates');
    if (!templates.existsSync()) {
      templates.createSync(recursive: true);
    }

    return templates.path;
  }

  // --------------------------------------------------------------------------
  // ⬇️ Download ZIP (EXACT C# behavior)
  // --------------------------------------------------------------------------
  Future<bool> downloadZip(String templateName) async {
    try {
      final primaryId = await LocalStorageService.getPrimaryId();
      final mac = await DeviceService.getDeviceId();

      if (primaryId == null) {
        print('❌ PrimaryScreenID missing');
        return false;
      }

      // 🔥 SAFE NAME FOR FILESYSTEM
      final safeName = _safeTemplateName(templateName);

      final dto = TemplateDownloadDto(
        screenId: primaryId,
        macProductId: mac,
        templateName: templateName, // ✅ FULL NAME SENT TO BACKEND
      );

      final url = Uri.parse(
        'https://117.219.19.154:8021/api/Task/DownloadTemplateFile',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode != 200) {
        print('❌ Download failed: ${response.body}');
        return false;
      }

      final base = await _downloadsDir();

      // ✅ USE SAFE NAME FOR ZIP
      final zipPath = '$base/$safeName.zip';

      await File(zipPath).writeAsBytes(response.bodyBytes);

      print('✅ ZIP saved at: $zipPath');
      return true;
    } catch (e, stack) {
      print('❌ DownloadZip exception: $e');
      print(stack);
      return false;
    }
  }

  // --------------------------------------------------------------------------
  // 📦 Extract ZIP → Downloads/Templates/<templateName>/
  // --------------------------------------------------------------------------
  Future<bool> extractTemplate(String templateName) async {
    try {
      final base = await _downloadsDir();

      // 🔥 SAME SAFE NAME
      final safeName = _safeTemplateName(templateName);

      final zipFile = File('$base/$safeName.zip');

      if (!zipFile.existsSync()) {
        print('❌ ZIP not found: ${zipFile.path}');
        return false;
      }

      final bytes = zipFile.readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);

      final outDir = Directory('$base/$safeName');
      if (!outDir.existsSync()) {
        outDir.createSync(recursive: true);
      }

      for (final file in archive) {
        final filePath = '${outDir.path}/${file.name}';
        if (file.isFile) {
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(file.content as List<int>);
        } else {
          Directory(filePath).createSync(recursive: true);
        }
      }

      print('✅ Extracted to: ${outDir.path}');
      return true;
    } catch (e, stack) {
      print('❌ extractTemplate failed: $e');
      print(stack);
      return false;
    }
  }

  String _safeTemplateName(String name) {
    return name.contains('\\') ? name.split('\\').last : name;
  }

  // --------------------------------------------------------------------------
  // 📂 Template Directory (used by dispatcher)
  // --------------------------------------------------------------------------
  Future<String> getTemplateDir() async {
    return _downloadsDir();
  }
}
