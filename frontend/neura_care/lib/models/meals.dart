import 'package:hive_flutter/hive_flutter.dart';
part "meals.g.dart";

@HiveType(typeId: 4)
class Meals {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  List<String> ingredients;
  @HiveField(3)
  String instructions;
  @HiveField(4)
  int prepTime;
  @HiveField(5)
  int cookTime;
  @HiveField(6)
  int servings;

  Meals({
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
  });
}