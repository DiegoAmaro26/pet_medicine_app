import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ConsultationService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getConsultations(int petId) async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/pets/$petId/consultations'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['data'];
    } else {
      throw Exception('Error cargando historial clínico');
    }
  }
}
