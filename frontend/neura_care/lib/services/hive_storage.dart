import 'package:hive_flutter/hive_flutter.dart';
import 'package:neura_care/models/user.dart';

final Box<User> userBox = Hive.box<User>('userBox');

User? getUser(){
  return userBox.get('user');
}

Future<void>  saveUser(User user) async {
  await userBox.put('user', user);
}

Future<void> removeUser() async {
  await userBox.delete('user');
}