import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:neura_care/models/user.dart';
import 'package:neura_care/models/vitals.dart';
import 'package:neura_care/models/diet.dart';
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
    headers: {'Content-Type': 'application/json', 'Cookie': 'token=$token'},
  );
  print(response.statusCode);
  if (response.statusCode != 200) {
    throw Exception('Failed to verify token');
  }
}

Future<Vitals> getUserVitals(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/vitals'),
    headers: {'Content-Type': 'application/json', 'Cookie': 'token=$token'},
  );
  print(jsonDecode(response.body));
  if (response.statusCode == 200) {
    try {
      return Vitals.fromJson(
       jsonDecode(response.body)["vitals"], 
      );
    } catch (e) {
      print(e);
      return Vitals.empty();
    }
  } else {
    if (response.statusCode == 404) {
      throw Exception('No vitals found for user');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Failed to fetch vitals');
    }
  }
}

Future<Vitals> updateUserVitals(String token, Vitals vitals) async {
  final response = await http.put(
    Uri.parse('$baseUrl/vitals'),
    headers: {'Content-Type': 'application/json', 'Cookie': 'token=$token'},
    body: jsonEncode(vitals.toJson()),
  );

  if (response.statusCode == 200) {
    return Vitals.fromJson(jsonDecode(response.body));
  } else {
    if (response.statusCode == 400) {
      throw Exception('Invalid vitals data');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Failed to update vitals');
    }
  }
}

Future<void> createUserVitals(String token, Vitals vitals) async {
  final response = await http.post(
    Uri.parse('$baseUrl/vitals'),
    headers: {'Content-Type': 'application/json', 'Cookie': 'token=$token'},
    body: jsonEncode(vitals.toJson()),
  );

  if (response.statusCode == 201) {
    return;
  } else {
    if (response.statusCode == 400) {
      throw Exception('Invalid vitals data');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else if (response.statusCode == 409) {
      throw Exception('Vitals already exist for user');
    } else {
      throw Exception('Failed to create vitals');
    }
  }
}

Future<double> getScore(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/healthScore'),
    headers: {'Content-Type': 'application/json', 'Cookie': 'token=$token'},
  );
  if (response.statusCode == 200) {
    print("Score fetched successfully");
    print(jsonDecode(response.body));
    return jsonDecode(response.body).toDouble();
  } else {
    if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch score');
    }
  }
}

Future<Diet> getUserDiet(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/diet'),
    headers: {'Content-Type': 'application/json', 'Cookie': 'token=$token'},
  );
  if (response.statusCode == 200) {
    print("Diet fetched successfully");
    print(jsonDecode(response.body));
    return Diet.fromJson(jsonDecode(response.body));
  } else {
    if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else if (response.statusCode == 404) {
      throw Exception('No diet plan found for user');
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch diet plan');
    }
  }
}

Future<void> updateUserDiet(String token, Diet diet) async {
  final response = await http.post(
    Uri.parse('$baseUrl/diet'),
    headers: {'Content-Type': 'application/json', 'Cookie': 'token=$token'},
    body: jsonEncode(diet.toJson()),
  );

  if (response.statusCode == 200) {
    return ;
  } else {
    print(response.statusCode);
    if (response.statusCode == 400) {
      throw Exception('Invalid diet data');
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    } else {
      throw Exception('Failed to update diet plan');
    }
  }
}