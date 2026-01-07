import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

class LocalWebServer {
  static HttpServer? _server;

  static Future<void> start(String rootPath, {int port = 8080}) async {
    if (_server != null) return;

    final handler = createStaticHandler(
      rootPath,
      defaultDocument: 'index.html',
      serveFilesOutsidePath: true,
    );

    _server = await shelf_io.serve(
      handler,
      InternetAddress.anyIPv4, // 🔥 IMPORTANT
      port,
    );

    print('🌐 Local server started on port $port');
  }

  static Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }
}
