
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/med.dart';
import 'package:neura_care/models/med_list.dart';

import 'package:neura_care/services/hive_storage.dart';

class MedListProvider extends StateNotifier<MedList> {
  MedListProvider() : super(MedList(meds: []));
  
  // Load medication list from Hive storage
  Future<void> loadMedList() async {
    try {
      final meds = await getMedList();
      if (meds != null) {
        state = meds;
      }
    } catch (e) {
      print('Error loading medication list: $e');
    }
  }
  
  Future<void> updateMedList(List<Med> meds) async {
    await saveMedList(MedList(meds: meds));
    state = MedList(meds: meds);
  }

  Future<void> clearMeds() async {
    await clearMedList();
    state = MedList(meds: []);
    
  }
}

final medListProviderNotifier = StateNotifierProvider<MedListProvider, MedList>((ref) {
  return MedListProvider();
});