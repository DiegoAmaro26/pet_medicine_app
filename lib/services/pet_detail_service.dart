import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class PetDetailService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<Map<String, dynamic>> getPet(int petId) async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/pets/$petId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error cargando mascota');
    }
  }
}
