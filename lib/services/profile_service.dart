import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ProfileService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  /// 👤 Obtener perfil del cliente
  Future<Map<String, dynamic>> getProfile() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Error cargando perfil');
    }
  }

  /// 🔐 Cambiar contraseña
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/profile/change-password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      }),
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['message'] ?? 'Error al cambiar contraseña');
    }
  }
}
