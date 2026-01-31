import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  // 10.0.2.2 = localhost desde el emulador Android

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/client/login');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Guardamos el token
      await _storage.write(
        key: 'auth_token',
        value: data['token'],
      );

      return true;
    } else {
      return false;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }
}
