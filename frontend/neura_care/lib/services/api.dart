import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:neura_care/models/user.dart';

final String baseUrl = dotenv.env['backendUrl']!;

Future<User> register(String email, String name, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/signup'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'name': name, 'password': password}),
  );

  if (response.statusCode == 201) {
    return User.fromJson(jsonDecode(response.body));
  } else {
      if (response.statusCode == 409) {
        throw Exception('Email already in use');
      } else if (response.statusCode == 400) {
        throw Exception('Invalid input data');
      } else {
    throw Exception('Failed to register user');
      }
  }
}

Future<User> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data);
    return User.fromJson(data);
  } else {
    if (response.statusCode == 401 || response.statusCode == 400) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Failed to login user');
    }
  }
}

Future<void> verifyToken(String token) async {
  print('Verifying token: $token');
  final response = await http.post(
    Uri.parse('$baseUrl/auth/verify-token'),
    headers: {
      'Content-Type': 'application/json',
      'Cookie': 'token=$token',
    },
  );
  print(response.statusCode);
  if (response.statusCode != 200) {
    throw Exception('Failed to verify token');
  }
}
