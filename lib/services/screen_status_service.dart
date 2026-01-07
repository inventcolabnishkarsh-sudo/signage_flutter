import 'dart:convert';
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
  Future<int?> isScreenRegistered({required String macProductId}) async {
    try {
      final response = await api.send(
        endpoint: 'Screen/IsScreenRegistered',
        method: 'POST',
        body: {'Mac_Product_ID': macProductId},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // 🔑 THIS FIXES EVERYTHING
        return json['Id']; // int?
      }

      return null;
    } catch (e) {
      print('❌ IsScreenRegistered failed: $e');
      return null;
    }
  }
}
