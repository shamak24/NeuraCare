
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/diet.dart';
import 'package:neura_care/services/hive_storage.dart';

class DietProvider extends StateNotifier<Diet> {
  DietProvider(): super(
    Diet.empty()
  );
  Future<void> loadDiet() async {
    final diet = await getDiet();
    if (diet != null) {
      state = diet;
    }
  }
  Future<void> setDiet(Diet diet) async {
    await saveDiet(diet);
    state = diet;
  }
  Future<void> clearDiet() async {
    await clearDietData();
    state = Diet.empty();
  }
}
final dietProvider = StateNotifierProvider<DietProvider, Diet>((ref) {
  return DietProvider();
});