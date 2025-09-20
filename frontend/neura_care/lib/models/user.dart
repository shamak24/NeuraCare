import 'package:hive_flutter/hive_flutter.dart';
import 'package:collection/collection.dart';
part "user.g.dart";
@HiveType(typeId: 0)
class User {
  User({
    required this.email,
    required this.name,
    this.healthScore = 0.0,
    this.token,
    required this.preventiveMeasures,
    required this.comorbidityAdvice,
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
  List<String> preventiveMeasures;
  @HiveField(5)
  String comorbidityAdvice;


  factory User.empty() {
    return User(email: '', name: '', healthScore: 0.0, token: null, preventiveMeasures: [], comorbidityAdvice: '');
  }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(email: json['email'], name: json['name'], token: json['token'], healthScore: json['healthScore']?.toDouble() ?? 0.0, preventiveMeasures: List<String>.from(json['preventiveMeasures'] ?? []), comorbidityAdvice: json['comorbidityAdvice'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {'email': email, 'name': name, 'token': token, 'healthScore': healthScore, 'preventiveMeasures': preventiveMeasures, 'comorbidityAdvice': comorbidityAdvice};
  }

  @override
  String toString() {
    return 'User(email: $email, name: $name, token: $token, healthScore: $healthScore, preventiveMeasures: $preventiveMeasures, comorbidityAdvice: $comorbidityAdvice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && 
           other.email == email && 
           other.name == name && 
           other.token == token &&
           const ListEquality().equals(other.preventiveMeasures, preventiveMeasures) && 
           other.comorbidityAdvice == comorbidityAdvice && 
           other.healthScore == healthScore;
  }

  @override
  int get hashCode {
    return email.hashCode ^ 
           name.hashCode ^ 
           token.hashCode ^
           const ListEquality().hash(preventiveMeasures) ^ 
           comorbidityAdvice.hashCode ^ 
           healthScore.hashCode;
  }
}
