import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ConsultationDetailService {
  final String _apiBaseUrl = 'http://10.0.2.2:8000/api';
  final String _storageBaseUrl = 'http://10.0.2.2:8000/storage';

  Future<Map<String, dynamic>> getConsultation(int consultationId) async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$_apiBaseUrl/consultations/$consultationId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Error cargando la consulta');
    }
  }

  Future<Uint8List> fetchProtectedFile(String path) async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$_storageBaseUrl/$path'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error cargando archivo');
    }
  }
}
