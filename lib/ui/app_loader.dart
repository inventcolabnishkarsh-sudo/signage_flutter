import 'package:flutter/material.dart';
import '../services/signage_config_service.dart';
import 'api_setup_screen.dart';
import '../app/app_bootstrap.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SignageConfigService.hasBaseUrl(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return AppBootstrap();
        } else {
          return ApiSetupScreen();
        }
      },
    );
  }
}
