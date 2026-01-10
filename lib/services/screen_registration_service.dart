import 'dart:convert';
import '../models/screen_register_dto.dart';
import '../config/app_config.dart';
import '../models/screen_register_model.dart';
import 'api_service.dart';
import 'local_storage_service.dart';

class ScreenRegistrationService {
  final ApiService api;

  ScreenRegistrationService(this.api);

  Future<ScreenRegisterResult?> registerScreen(ScreenRegisterDTO dto) async {
    try {
      final response = await api.send(
        endpoint: AppConfig.registerEndpoint,
        method: 'POST',
        body: dto.toJson(),
      );

      print('Register status code: ${response.statusCode}');
      print('Register response body: ${response.body}');

      // ✅ SUCCESS WITH BODY
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final json = jsonDecode(response.body);

        return ScreenRegisterResult(
          screenId: json['Id'],
          screenStatus: json['ScreenStatus'], // 🔥 THIS IS THE FIX
        );
      }

      // ✅ PENDING (NO BODY)
      if (response.statusCode == 204) {
        return ScreenRegisterResult(
          screenId: null,
          screenStatus: 1, // Pending
        );
      }

      return null;
    } catch (e, stack) {
      print('Register exception: $e');
      print(stack);
      return null;
    }
  }
}
