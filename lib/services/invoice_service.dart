import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class InvoiceService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getInvoices() async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/invoices'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Error cargando facturas');
    }
  }

  Future<Uint8List> downloadInvoicePdf(int id) async {
    final token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/invoices/$id/pdf'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/pdf',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Error descargando PDF');
    }
  }
}
