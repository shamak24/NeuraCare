
import 'package:hive_flutter/hive_flutter.dart';

part "diet.g.dart";
enum CuisineType{
  North, South, Indian, Mexican, Italian, West, Continental
}

@HiveType(typeId: 2)
class Diet{
  @HiveField(0)
  bool vegan;
  @HiveField(1)
  bool vegetarian;
  @HiveField(2)
  bool glutenFree;
  @HiveField(3)
  bool lactoseFree;
  @HiveField(4)
  bool keto;
  @HiveField(5)
  List<CuisineType> cuisinePreference;
  @HiveField(6)
  List<String> allergies;

  Diet({
    required this.vegan,
    required this.vegetarian,
    required this.glutenFree,
    required this.lactoseFree,
    required this.keto,
    required this.cuisinePreference,
    required this.allergies,
  });
}