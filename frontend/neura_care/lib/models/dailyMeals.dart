
import 'package:neura_care/models/meal.dart';
import "package:hive_flutter/hive_flutter.dart";
part 'dailyMeals.g.dart';
@HiveType(typeId: 4)
class DailyMeals {
  @HiveField(0)
  Meal breakfast;
  @HiveField(1)
  Meal lunch;
  @HiveField(2)
  Meal dinner;
  @HiveField(3)
  DateTime date;

  DailyMeals({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.date,
  });

  factory DailyMeals.empty() {
    return DailyMeals(
      breakfast: Meal.empty(),
      lunch: Meal.empty(),
      dinner: Meal.empty(),
      date: DateTime.now(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.toJson(),
      'lunch': lunch.toJson(),
      'dinner': dinner.toJson(),
      'date': date.toIso8601String(),
    };
  }
  factory DailyMeals.fromJson(Map<String, dynamic> json) {
    return DailyMeals(
      breakfast: Meal.fromJson(json['breakfast'] ?? {}),
      lunch: Meal.fromJson(json['lunch'] ?? {}),
      dinner: Meal.fromJson(json['dinner'] ?? {}),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}
