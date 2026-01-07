import 'dart:convert';
import '../models/screen_register_dto.dart';
import '../config/app_config.dart';
import 'api_service.dart';
import 'local_storage_service.dart';

class ScreenRegistrationService {
  final ApiService api;

  ScreenRegistrationService(this.api);

  Future<int?> registerScreen(ScreenRegisterDTO dto) async {
    try {
      final response = await api.send(
        endpoint: AppConfig.registerEndpoint,
        method: 'POST',
        body: dto.toJson(),
      );

      print('Register status code: ${response.statusCode}');
      print('Register response body: ${response.body}');

      // ✅ SUCCESS WITH BODY (APPROVED)
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final json = jsonDecode(response.body);
        final int primaryId = json['Id'];

        // 🔐 STORE PRIMARY ID LOCALLY
        await LocalStorageService.savePrimaryId(primaryId);

        print('✅ PrimaryId saved locally: $primaryId');

        return primaryId;
      }

      // ✅ SUCCESS WITHOUT BODY (PENDING)
      if (response.statusCode == 204) {
        return null; // Still SUCCESS
      }

      // ❌ REAL FAILURE
      return -1;
    } catch (e, stack) {
      print('Register exception: $e');
      print(stack);
      return -1;
    }
  }
}
