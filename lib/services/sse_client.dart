import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/sse_message.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/sse_message.dart';

class SseClient {
  final String url;
  bool _keepRunning = false;
  HttpClient? _client;

  void Function(SseMessage message)? onMessageReceived;

  SseClient(this.url);

  void start() {
    if (_keepRunning) return;
    _keepRunning = true;
    _listen();
  }

  void stop() {
    _keepRunning = false;
    _client?.close(force: true);
  }

  Future<void> _listen() async {
    while (_keepRunning) {
      try {
        _client = HttpClient()..connectionTimeout = const Duration(seconds: 15);

        final request = await _client!.getUrl(Uri.parse(url));

        // SAME BEHAVIOR AS HttpWebRequest
        request.headers.set(HttpHeaders.acceptHeader, 'text/event-stream');
        request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
        request.headers.set(HttpHeaders.connectionHeader, 'keep-alive');

        final response = await request.close();

        print('📡 SSE HTTP STATUS => ${response.statusCode}');

        if (response.statusCode != 200) {
          throw Exception('SSE status ${response.statusCode}');
        }

        print('📡 SSE CONNECTED');

        final stream = response.transform(utf8.decoder);
        final lines = stream.transform(const LineSplitter());

        await for (final line in lines) {
          if (!_keepRunning) break;

          // EXACT MATCH WITH C#
          if (line.startsWith('data:')) {
            final jsonStr = line.substring(5).trim();

            if (jsonStr.isEmpty) continue;

            // ✅ PRINT RAW JSON (EXACT backend payload)
            print('📨 SSE RAW JSON => $jsonStr');

            try {
              final map = jsonDecode(jsonStr);
              final msg = SseMessage.fromJson(map);
              onMessageReceived?.call(msg);
            } catch (e) {
              print('❌ SSE parse error: $e');
            }
          }
        }
      } catch (e) {
        print('⚠️ SSE disconnected: $e');
        await Future.delayed(
          const Duration(seconds: 10),
        ); // SAME reconnect logic
      }
    }
  }
}
