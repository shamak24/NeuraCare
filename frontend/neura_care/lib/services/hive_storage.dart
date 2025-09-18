import 'package:hive_flutter/hive_flutter.dart';
import 'package:neura_care/models/user.dart';
import 'package:neura_care/models/vitals.dart';

final Box<User> userBox = Hive.box<User>('userBox');
final Box<Vitals> vitalsBox = Hive.box<Vitals>('vitalsBox');
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
