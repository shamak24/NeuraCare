import 'package:hive_flutter/hive_flutter.dart';
part "vitals.g.dart";

@HiveType(typeId: 1)
class Vitals {
  @HiveField(0)
  double bloodPressure;
  @HiveField(1)
  int heartRate;
  @HiveField(2)
  double sugarLevel;
  @HiveField(3)
  double weight;
  @HiveField(4)
  double cholesterol;
  @HiveField(5)
  String activityLevel;
  @HiveField(6)
  String gender;
  @HiveField(7)
  int age;
  @HiveField(8)
  double height;
  Vitals({
    required this.bloodPressure,
    required this.heartRate,
    required this.sugarLevel,
    required this.weight,
    required this.cholesterol,
    required this.activityLevel,
    required this.gender,
    required this.age,
    required this.height,
  });
  factory Vitals.empty() {
    return Vitals(
      bloodPressure: 0.0,
      heartRate: 0,
      sugarLevel: 0.0,
      weight: 0.0,
      cholesterol: 0.0,
      activityLevel: '',
      gender: '',
      age: 0,
      height: 0.0,
    );
  }

  factory Vitals.fromJson(Map<String, dynamic> json) {
    print(json);
    return Vitals(
      bloodPressure: json['bloodPressure'].toDouble(),
      heartRate: json['heartRate'],
      sugarLevel: json['sugarLevel'].toDouble(),
      weight: json['weight'].toDouble(),
      cholesterol: json['cholesterol'].toDouble(),
      activityLevel: json['activityLevel'],
      gender: json['gender'],
      age: json['age'],
      height: json['height'].toDouble(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vitals &&
        bloodPressure == other.bloodPressure &&
        heartRate == other.heartRate &&
        sugarLevel == other.sugarLevel &&
        weight == other.weight &&
        cholesterol == other.cholesterol &&
        activityLevel == other.activityLevel &&
        age == other.age &&
        gender == other.gender &&
        height == other.height;
  }

  @override
  int get hashCode {
    return bloodPressure.hashCode ^
        heartRate.hashCode ^
        sugarLevel.hashCode ^
        weight.hashCode ^
        cholesterol.hashCode ^
        activityLevel.hashCode ^
        gender.hashCode ^
        age.hashCode ^
        height.hashCode;
  }

  @override
  String toString() {
    return 'Vitals(bloodPressure: $bloodPressure, heartRate: $heartRate, sugarLevel: $sugarLevel, weight: $weight, cholesterol: $cholesterol, activityLevel: $activityLevel, gender: $gender, age: $age, height: $height)';
  }
}
