
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
      // Use a fixed epoch date for the empty sentinel so equality is stable
      date: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  /// Returns true when all meals are empty (used as a stable "empty" check)
  bool get isEmpty {
    return breakfast == Meal.empty() &&
        lunch == Meal.empty() &&
        dinner == Meal.empty();
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
  @override
  String toString() {
    return 'DailyMeals(breakfast: $breakfast, lunch: $lunch, dinner: $dinner, date: $date)';
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DailyMeals &&
        other.breakfast == breakfast &&
        other.lunch == lunch &&
        other.dinner == dinner &&
        other.date == date;
  }
  @override
  int get hashCode {
    return breakfast.hashCode ^
        lunch.hashCode ^
        dinner.hashCode ^
        date.hashCode;
  }
}
