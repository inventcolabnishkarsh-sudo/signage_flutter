import 'dart:typed_data';
import 'dart:convert';
import 'package:intl/intl.dart';

class Crc32 {
  static const int _defaultPolynomial = 0xEDB88320;
  static const int _defaultSeed = 0xFFFFFFFF;

  static final List<int> _defaultTable = _initializeTable(_defaultPolynomial);

  static int compute(Uint8List data, {int seed = _defaultSeed}) {
    int crc = seed;

    for (final byte in data) {
      crc = (crc >> 8) ^ _defaultTable[(crc ^ byte) & 0xFF];
    }

    return ~crc & 0xFFFFFFFF;
  }

  static List<int> _initializeTable(int polynomial) {
    final table = List<int>.filled(256, 0);

    for (int i = 0; i < 256; i++) {
      int entry = i;
      for (int j = 0; j < 8; j++) {
        if ((entry & 1) == 1) {
          entry = (entry >> 1) ^ polynomial;
        } else {
          entry >>= 1;
        }
      }
      table[i] = entry;
    }
    return table;
  }
}

String generateConnectionCode({
  required String playerType,
  required String macAddress,
}) {
  final now = DateTime.now();

  // EXACT format: yyyy-MM-dd HH:mm:ss
  final timestamp =
      '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')} '
      '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}';

  final buffer = '$playerType#$macAddress#$timestamp';

  final bytes = Uint8List.fromList(utf8.encode(buffer));
  final crc = Crc32.compute(bytes);

  // EXACT equivalent of C# ToString("X8")
  return crc.toRadixString(16).toUpperCase().padLeft(8, '0');
}
