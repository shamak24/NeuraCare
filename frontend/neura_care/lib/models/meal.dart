import 'package:hive_flutter/hive_flutter.dart';
import 'package:collection/collection.dart';

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
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Meal &&
        other.mealName == mealName &&
        ListEquality().equals(other.ingredients, ingredients) &&
        ListEquality().equals(other.instructions, instructions);
  }

  @override
  int get hashCode =>
      mealName.hashCode ^ ingredients.hashCode ^ instructions.hashCode;

  @override
  String toString() =>
      'Meal(mealName: $mealName, ingredients: $ingredients, instructions: $instructions)';
}
