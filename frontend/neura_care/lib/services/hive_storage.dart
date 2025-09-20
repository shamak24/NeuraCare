import 'package:hive_flutter/hive_flutter.dart';
import 'package:neura_care/models/dailyMeals.dart';
import 'package:neura_care/models/diet.dart';
import 'package:neura_care/models/user.dart';
import 'package:neura_care/models/vitals.dart';

final Box<User> userBox = Hive.box<User>('userBox');
final Box<Vitals> vitalsBox = Hive.box<Vitals>('vitalsBox');
final Box<DailyMeals> dailyMealsBox = Hive.box<DailyMeals>('dailyMealsBox');
final Box<Diet> dietBox = Hive.box<Diet>('dietBox');
User? getUser() {
  return userBox.get('user');
}

Future<void> saveUser(User user) async {
  await userBox.put('user', user);
}

Future<void> clearUserData() async {
  await userBox.delete('user');
}

Vitals? getVitals() {
  return vitalsBox.get('vitals');
}

Future<void> saveVitals(Vitals vitals) async {
  await vitalsBox.put('vitals', vitals);
}

Future<void> clearVitalsData() async {
  await vitalsBox.delete('vitals');
}

DailyMeals? getDailyMeals() {
  return dailyMealsBox.get('dailyMeals');
}
Future<void> saveDailyMeals(DailyMeals meals) async {
  await dailyMealsBox.put('dailyMeals', meals);
}
Future<void> clearDailyMealsData() async {
  await dailyMealsBox.delete('dailyMeals');
}
Future<Diet?> getDiet() async {
  return dietBox.get('diet');
}
Future<void> saveDiet(Diet diet) async {
  await dietBox.put('diet', diet);
}
Future<void> clearDietData() async {
  await dietBox.delete('diet');
}
