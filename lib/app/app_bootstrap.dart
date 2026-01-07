import 'package:flutter/material.dart';
import '../services/signage_config_service.dart';
import '../services/api_service.dart';
import '../utils/app_toast.dart';
import 'app_controller.dart';
import '../ui/homescreen.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  AppController? _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    AppToast.show('Starting application');

    final baseUrl = await SignageConfigService.getBaseUrl();
    print('🟠 Loaded baseUrl => $baseUrl');
    AppToast.show('Config loaded');
    print('🟠 AppController created inside AppBootstrap');
    final apiService = ApiService(baseUrl: baseUrl!);
    final controller = AppController(apiService: apiService);

    AppToast.show('Controller initialized');

    controller.start();

    setState(() {
      _controller = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return HomeScreen(controller: _controller!);
  }
}
