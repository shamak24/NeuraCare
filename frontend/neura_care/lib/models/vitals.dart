import 'package:hive_flutter/hive_flutter.dart';
part "vitals.g.dart";

@HiveType(typeId: 1)
class Vitals {
  @HiveField(0)
  int bloodPressure;
  @HiveField(1)
  int heartRate;
  @HiveField(2)
  int sugarLevel;
  @HiveField(3)
  int weight;
  @HiveField(4)
  int cholesterol;
  @HiveField(5)
  String activityLevel;

  Vitals({
    required this.bloodPressure,
    required this.heartRate,
    required this.sugarLevel,
    required this.weight,
    required this.cholesterol,
    required this.activityLevel,
  });
  factory Vitals.empty() {
    return Vitals(
      bloodPressure: 0,
      heartRate: 0,
      sugarLevel: 0,
      weight: 0,
      cholesterol: 0,
      activityLevel: '',
    );
  }
}
