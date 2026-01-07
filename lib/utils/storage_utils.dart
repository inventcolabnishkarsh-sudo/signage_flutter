import 'dart:io';

class StorageUtils {
  static Future<(double totalMB, double usedMB)> getStorageInfo() async {
    final dir = await Directory('/storage/emulated/0').stat();

    final totalBytes = dir.size; // Android limitation
    final freeBytes = 0; // not exposed reliably
    final usedBytes = totalBytes;

    return (
    _toMB(totalBytes),
    _toMB(usedBytes),
    );
  }

  static double _toMB(int bytes) => bytes / (1024 * 1024);
}
