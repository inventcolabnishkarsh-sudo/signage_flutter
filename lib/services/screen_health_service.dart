import 'dart:convert';
import '../models/screen_health_details_dto.dart';
import 'api_service.dart';
import '../models/sse_message.dart';

class ScreenHealthService {
  final ApiService api;

  ScreenHealthService(this.api);

  /// 🔁 EXACT equivalent of WinForms SendHealthDetails()
  /// - POST
  /// - 200/204 = success
  /// - Optional command in response
  Future<SseMessage?> sendHealth(ScreenHealthDetailsDTO dto) async {
    try {
      final response = await api.send(
        endpoint: 'Screen/ScreenHealthDetails',
        method: 'POST',
        body: dto.toJson(),
      );

      // ✅ SUCCESS CASES (same as IsSuccessStatusCode)
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isNotEmpty) {
          return SseMessage.fromJson(jsonDecode(response.body));
        }
        return null; // normal heartbeat
      }

      // ❌ REAL FAILURE
      print('❌ Health API failed: ${response.statusCode}');
      return null;
    } catch (e, stack) {
      // ❗ Never crash health loop
      print('❌ SendHealthDetails exception: $e');
      print(stack);
      return null;
    }
  }
}
