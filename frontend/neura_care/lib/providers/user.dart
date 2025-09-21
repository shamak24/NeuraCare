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
  void clearUser() async {
    await deleteAllData();
    state = User.empty();
    
  }
  void updateHealthInfo(Map<String, dynamic> healthInfo) async {
    state.healthScore = healthInfo['healthScore']?.toDouble() ?? 0.0;
    state.preventiveMeasures = List<String>.from(healthInfo['preventiveMeasures'] ?? []);
    state.comorbidityAdvice = healthInfo['comorbidityAdvice'] ?? '';
    state.risks = List<String>.from(healthInfo['risks'] ?? []);
    await saveUser(state);
  }
  
}

final userProviderNotifier = StateNotifierProvider<UserProvider, User>((ref) {
  return UserProvider();
});