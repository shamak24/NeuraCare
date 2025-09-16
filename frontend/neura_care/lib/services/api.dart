import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:neura_care/models/user.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<User> register(String email, String name, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'name': name,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      
      return User.empty();
    } else {
      print(response.body);
      throw Exception('Failed to register user');
    }
  }
}


final apiServiceInstance = ApiService(baseUrl: dotenv.env['backendUrl']!);