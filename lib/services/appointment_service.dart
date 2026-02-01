import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class AppointmentService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getUpcomingAppointments() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/appointments/upcoming'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Error cargando citas');
    }
  }
}

