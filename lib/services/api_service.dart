import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/token_dto.dart';

class ApiService {
  static const _storage = FlutterSecureStorage();

  final String baseUrl;
  final String refreshTokenEndpoint = 'User/RefreshToken';

  ApiService({required this.baseUrl});

  Future<http.Response> send({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    String? accessToken = await _storage.read(key: 'accessToken');
    String? refreshToken = await _storage.read(key: 'refreshToken');

    http.Response response = await _request(
      endpoint,
      method,
      body,
      accessToken,
    );

    // 🔁 Retry once on 401
    if (response.statusCode == 401 && refreshToken != null) {
      print('🔁 401 received, attempting token refresh');

      final refreshed = await _refreshToken(accessToken, refreshToken);

      if (refreshed != null) {
        await _storage.write(key: 'accessToken', value: refreshed.accessToken);
        await _storage.write(
          key: 'refreshToken',
          value: refreshed.refreshToken,
        );

        response = await _request(
          endpoint,
          method,
          body,
          refreshed.accessToken,
        );
      }
    }

    return response;
  }

  Future<http.Response> _request(
    String endpoint,
    String method,
    Map<String, dynamic>? body,
    String? token,
  )
  async {
    final uri = _buildUri(endpoint);

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('➡️ API REQUEST');
    print('METHOD: $method');
    print('URL: $uri');
    print('HEADERS: $headers');
    print('BODY: ${body != null ? jsonEncode(body) : 'null'}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    late http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method');
      }

      print('⬅️ API RESPONSE');
      print('STATUS CODE: ${response.statusCode}');
      print('BODY: ${response.body}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      return response;
    } catch (e, stack) {
      print('❌ API ERROR');
      print(e);
      print(stack);
      rethrow;
    }
  }

  Future<TokenDTO?> _refreshToken(
    String? accessToken,
    String refreshToken,
  )
  async {
    final uri = _buildUri(refreshTokenEndpoint);

    print('🔐 REFRESH TOKEN REQUEST');
    print('URL: $uri');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      }),
    );

    print('🔐 REFRESH RESPONSE: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      return TokenDTO.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  /// 🔒 Single safe URL builder
  Uri _buildUri(String endpoint) {
    return Uri.parse(
      '${baseUrl.replaceAll(RegExp(r'/+$'), '')}'
      '/${endpoint.replaceAll(RegExp(r'^/+'), '')}',
    );
  }
}
