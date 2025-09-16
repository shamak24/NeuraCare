import 'package:hive_flutter/hive_flutter.dart';
part "user.g.dart";
@HiveType(typeId: 0)
class User {
  User({
    required this.email,
    required this.name,
    this.token,
  });
  @HiveField(0)
  final String email;
  @HiveField(1)
  final String? token;
  @HiveField(2)
  final String name;



  factory User.empty() {
    return User(email: '', name: '');
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(email: json['email'], name: json['name'], token: json['token']);
  }
  Map<String, dynamic> toJson() {
    return {'email': email, 'name': name, 'token': token};
  }

  @override
  String toString() {
    return 'User(email: $email, name: $name, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.email == email && other.name == name;
  }

  @override
  int get hashCode {
    return email.hashCode ^ name.hashCode;
  }
}
