
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neura_care/models/prev_history.dart';
import 'package:neura_care/services/hive_storage.dart';

class PrevHistoryProvider extends StateNotifier<PreviousHistory> {
  PrevHistoryProvider() : super(PreviousHistory.empty());

  void loadPrevHistory() {
    PreviousHistory? history = getPrevHistory();
    if (history != null) {
      state = history;
    }
  }

  Future<void> savePrevHistory(PreviousHistory history) async {
    await savePrevHistoryData(history);
    state = history;
  }
  Future<void> clearPrevHistory() async {
    await clearPrevHistoryData();
    state = PreviousHistory.empty();
  }
}

final prevHistoryProviderNotifier =
    StateNotifierProvider<PrevHistoryProvider, PreviousHistory>((ref) {
  return PrevHistoryProvider();
});