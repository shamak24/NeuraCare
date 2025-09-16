import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/user.dart';
import 'package:neura_care/services/hive_storage.dart';


class UserProvider extends StateNotifier<User> {
  UserProvider() : super(User.empty());
  void loadUserData() async {
     User? user = getUser();
     if (user != null) {
       state = user;
     } 
  }
  
}

final userProviderNotifier = StateNotifierProvider<UserProvider, User>((ref) {
  return UserProvider();
});