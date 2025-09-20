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
  void setUser(User user) {
    saveUser(user);
    state = user;
  }
  void clearUser() {
    clearUserData();
    state = User.empty();
    
  }
  void updateHealthScore(double score) async {
    state.healthScore = score;
    await saveUser(state);
  }
  
}

final userProviderNotifier = StateNotifierProvider<UserProvider, User>((ref) {
  return UserProvider();
});