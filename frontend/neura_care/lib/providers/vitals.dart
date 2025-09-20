import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/vitals.dart';
import 'package:neura_care/services/hive_storage.dart';

class VitalsProvider extends StateNotifier<Vitals> {
  VitalsProvider() : super(Vitals.empty());
  void loadVitalsData() async {
    Vitals? vitals = getVitals();
    if (vitals != null) {
      state = vitals;
    }
  }

  void setVitals(Vitals vitals) {
    saveVitals(vitals);
    state = vitals;
  }

  void clearVitals() {
    clearVitalsData();
    state = Vitals.empty();
  }
}

final vitalsProviderNotifier =
    StateNotifierProvider<VitalsProvider, Vitals>((ref) {
  return VitalsProvider();
});
