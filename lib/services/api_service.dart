import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  static Future<String> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    return response.body;
  }

  static Future<bool> cadastrar(String nome, String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
    );

    return response.statusCode == 200;
  }

  static Future<List> buscarLeituras() async {
    final response = await http.get(Uri.parse('$baseUrl/leituras'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  static Future<bool> alterarIrrigacao(bool ligada) async {
    final response = await http.post(
      Uri.parse('$baseUrl/irrigacoes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ligada': ligada}),
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>> buscarRelatorio() async {
    final response = await http.get(Uri.parse('$baseUrl/relatorios'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return {};
  }
}
