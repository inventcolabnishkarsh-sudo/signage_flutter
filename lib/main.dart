import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signage/services/local_storage_service.dart';
import 'package:signage/services/signage_config_service.dart';
import 'package:signage/ui/app_loader.dart';
import 'package:signage/ui/homescreen.dart';
import 'app/app_controller.dart';
import 'services/api_service.dart';
import 'config/app_config.dart';
import 'core/http_overrides.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'package:webview_flutter_android/webview_flutter_android.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  }

  await LocalStorageService.init();
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: AppLoader()),
  );
}

class MyApp extends StatefulWidget {
  final AppController controller;

  const MyApp({super.key, required this.controller});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _started = false; // 🛡 prevents double start (hot reload safe)

  @override
  void initState() {
    super.initState();
    print('🟣 MyApp.initState()');

    /// ✅ START AFTER FIRST FRAME
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🟣 First frame rendered');
      if (_started) return;
      _started = true;
      print('🟣 Calling AppController.start()');
      //TEST URL
      widget.controller.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(controller: widget.controller),
    );
  }
}

//https://117.219.19.154:8021/api/
