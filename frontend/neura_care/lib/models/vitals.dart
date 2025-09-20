import 'package:hive_flutter/hive_flutter.dart';
part "vitals.g.dart";

@HiveType(typeId: 1)
class Vitals {
  @HiveField(0)
  int bpHigh;
  @HiveField(1)
  int bpLow;
  @HiveField(2)
  int heartRate;
  @HiveField(3)
  int sugarLevel;
  @HiveField(4)
  double weight;
  @HiveField(5)
  int cholesterol;
  @HiveField(6)
  String activityLevel;
  @HiveField(7)
  String gender;
  @HiveField(8)
  int age;
  @HiveField(9)
  double height;
  @HiveField(10)
  bool smoking;
  @HiveField(11)
  bool drinking;
  @HiveField(12)
  double sleepHours;
  Vitals({
    required this.bpHigh,
    required this.bpLow,
    required this.heartRate,
    required this.sugarLevel,
    required this.weight,
    required this.cholesterol,
    required this.activityLevel,
    required this.gender,
    required this.age,
    required this.height,
    required this.smoking,
    required this.drinking,
    required this.sleepHours,
  });
  factory Vitals.empty() {
    return Vitals(
      bpHigh: 0,
      bpLow: 0,
      heartRate: 0,
      sugarLevel: 0,
      weight: 0,
      cholesterol: 0,
      activityLevel: '',
      gender: '',
      age: 0,
      height: 0.0,
      smoking: false,
      drinking: false,
      sleepHours: 0.0,
    );
  }

  factory Vitals.fromJson(Map<String, dynamic> json) {
    print(json);
    return Vitals(
      bpHigh: json["bpHigh"],
      bpLow: json["bpLow"],
      heartRate: json['heartRate'],
      sugarLevel: json['sugarLevel'],
      weight: json['weight'],
      cholesterol: json['cholesterol'],
      activityLevel: json['activityLevel'],
      gender: json['gender'],
      age: json['age'],
      height: json['height'],
      smoking: json['smoking'] ?? false,
      drinking: json['drinking'] ?? false,
      sleepHours: (json['sleepHours'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bpHigh': bpHigh,
      'bpLow': bpLow,
      'heartRate': heartRate,
      'sugarLevel': sugarLevel,
      'weight': weight,
      'cholesterol': cholesterol,
      'activityLevel': activityLevel,
      'gender': gender,
      'age': age,
      'height': height,
      'smoking': smoking,
      'drinking': drinking,
      'sleepHours': sleepHours,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vitals &&
        bpHigh == other.bpHigh &&
        bpLow == other.bpLow &&
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
    return bpHigh.hashCode ^
        bpLow.hashCode ^
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
    return 'Vitals(bpHigh: $bpHigh, bpLow: $bpLow, heartRate: $heartRate, sugarLevel: $sugarLevel, weight: $weight, cholesterol: $cholesterol, activityLevel: $activityLevel, gender: $gender, age: $age, height: $height)';
  }
}
