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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DailyMealsProvider &&
        other.state.breakfast == state.breakfast &&
        other.state.lunch == state.lunch &&
        other.state.dinner == state.dinner;
  }
  @override
  int get hashCode => state.breakfast.hashCode ^ state.lunch.hashCode ^ state.dinner.hashCode;
}


final dailyMealsProviderNotifier = StateNotifierProvider<DailyMealsProvider, DailyMeals>((ref) {
  return DailyMealsProvider();
});