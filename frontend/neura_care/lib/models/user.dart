import 'package:hive_flutter/hive_flutter.dart';
part "user.g.dart";
@HiveType(typeId: 0)
class User {
  User({
    required this.email,
    required this.name,
    this.healthScore = 0.0,
    this.token,
    this.healthPoints = 0.0,
  });
  @HiveField(0)
  final String email;
  @HiveField(1)
  final String? token;
  @HiveField(2)
  final String name;
  @HiveField(3)
  double healthScore;
  @HiveField(4)
  double healthPoints;


  factory User.empty() {
    return User(email: '', name: '', healthScore: 0.0);
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(email: json['email'], name: json['name'], token: json['token'], healthScore: json['healthScore']?.toDouble() ?? 0.0, healthPoints: json['healthPoints']?.toDouble() ?? 0.0);
  }
  Map<String, dynamic> toJson() {
    return {'email': email, 'name': name, 'token': token, 'healthScore': healthScore, 'healthPoints': healthPoints};
  }

  @override
  String toString() {
    return 'User(email: $email, name: $name, token: $token, healthScore: $healthScore, healthPoints: $healthPoints)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.email == email && other.name == name && other.healthPoints == healthPoints && other.healthScore == healthScore;
  }

  @override
  int get hashCode {
    return email.hashCode ^ name.hashCode ^ healthPoints.hashCode ^ healthScore.hashCode;
  }
}
