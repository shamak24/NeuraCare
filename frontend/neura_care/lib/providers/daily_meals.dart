import 'package:neura_care/models/dailyMeals.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:neura_care/models/meal.dart';
import 'package:neura_care/services/hive_storage.dart';


class DailyMealsProvider extends StateNotifier<DailyMeals>{
  DailyMealsProvider() : super(DailyMeals(
    breakfast: Meal.empty(),
    lunch: Meal.empty(),
    dinner: Meal.empty(),
    date: DateTime.now(),
  ));

  void loadDailyMeals() {
    final meals = getDailyMeals();
    if (meals != null) {
      state = meals;
    }
  }

  void setDailyMeals(DailyMeals meals) async {
    await saveDailyMeals(meals);
    state = meals;
  }
  void clearDailyMeals() async {
    await clearDailyMealsData();
    state = DailyMeals(
      breakfast: Meal.empty(),
      lunch: Meal.empty(),
      dinner: Meal.empty(),
      date: DateTime.now(),
    );
  }
}

final dailyMealsProviderNotifier = StateNotifierProvider<DailyMealsProvider, DailyMeals>((ref) {
  return DailyMealsProvider();
});