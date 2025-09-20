import 'package:hive_flutter/hive_flutter.dart';

part 'meal.g.dart';

@HiveType(typeId: 6)
class Meal {
  @HiveField(0)
  String mealName;
  @HiveField(1)
  List<String> ingredients;
  @HiveField(2)
  List<String> instructions;

  Meal({
    required this.mealName,
    required this.ingredients,
    required this.instructions,
  });

  factory Meal.empty() {
    return Meal(mealName: '', ingredients: [], instructions: []);
  }
  Map<String, dynamic> toJson() {
    return {
      'mealName': mealName,
      'ingredients': ingredients,
      'instructions': instructions,
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealName: json['mealName'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }
}
