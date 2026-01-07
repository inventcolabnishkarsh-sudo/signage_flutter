import 'api_service.dart';

class ConnectivityService {
  final ApiService api;

  ConnectivityService(this.api);

  Future<bool> checkConnectivity() async {
    final response = await api.send(
      endpoint: 'Screen/CheckConnectivity',
      method: 'POST',
      body: {'systemDateTime': DateTime.now().toIso8601String()},
    );

    return response.statusCode == 200;
  }
}
