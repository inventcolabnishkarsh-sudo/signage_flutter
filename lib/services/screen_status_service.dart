import 'dart:convert';
import '../models/screen_status_result.dart';
import 'api_service.dart';

class ScreenStatusService {
  final ApiService api;

  ScreenStatusService(this.api);

  /// API: Screen/IsScreenRegistered
  /// Body: { Mac_Product_ID }
  ///
  /// Returns:
  /// - screenId (int) → Approved
  /// - null → Pending / Not registered
  Future<ScreenStatusResult?> getScreenStatus({
    required String macProductId,
  }) async {
    try {
      final response = await api.send(
        endpoint: 'Screen/IsScreenRegistered',
        method: 'POST',
        body: {'Mac_Product_ID': macProductId},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return ScreenStatusResult(
          screenId: json['Id'],
          screenStatus: json['ScreenStatus'], // 🔥 IMPORTANT
        );
      }
      return null;
    } catch (e) {
      print('❌ getScreenStatus failed: $e');
      return null;
    }
  }
}
