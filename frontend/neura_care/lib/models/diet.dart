
import 'package:hive_flutter/hive_flutter.dart';
import 'package:collection/collection.dart';

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
  List<CuisineType> cuisinePreferences;
  @HiveField(6)
  List<String> allergies;

  Diet({
    required this.vegan,
    required this.vegetarian,
    required this.glutenFree,
    required this.lactoseFree,
    required this.keto,
    required this.cuisinePreferences,
    required this.allergies,
  });

  factory Diet.empty(){
    return Diet(
      vegan: false,
      vegetarian: false,
      glutenFree: false,
      lactoseFree: false,
      keto: false,
      cuisinePreferences: [],
      allergies: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vegan': vegan,
      'vegetarian': vegetarian,
      'glutenFree': glutenFree,
      'lactoseFree': lactoseFree,
      'keto': keto,
      'cuisinePreference': cuisinePreferences.map((e) => e.toString().split('.').last).toList(),
      'allergies': allergies,
    };
  }
  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      vegan: json['vegan'],
      vegetarian: json['vegetarian'],
      glutenFree: json['glutenFree'],
      lactoseFree: json['lactoseFree'],
      keto: json['keto'],
      cuisinePreferences: (json['cuisinePreference'] as List<dynamic>).map((e) => CuisineType.values.firstWhere((element) => element.toString() == 'CuisineType.$e')).toList(),
      allergies: List<String>.from(json['allergies']),
    );
  }

  @override
  String toString() {
    return 'Diet(vegan: $vegan, vegetarian: $vegetarian, glutenFree: $glutenFree, lactoseFree: $lactoseFree, keto: $keto, cuisinePreferences: $cuisinePreferences, allergies: $allergies)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Diet &&
        other.vegan == vegan &&
        other.vegetarian == vegetarian &&
        other.glutenFree == glutenFree &&
        other.lactoseFree == lactoseFree &&
        other.keto == keto &&
        ListEquality().equals(other.cuisinePreferences, cuisinePreferences) &&
        ListEquality().equals(other.allergies, allergies);
  }
  @override
  int get hashCode {
    return vegan.hashCode ^
        vegetarian.hashCode ^
        glutenFree.hashCode ^
        lactoseFree.hashCode ^
        keto.hashCode ^
        cuisinePreferences.hashCode ^
        allergies.hashCode;
  }
}
