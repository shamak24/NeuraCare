
import 'package:hive_flutter/hive_flutter.dart';

part "prev_history.g.dart";

@HiveType(typeId: 3)
class PreviousHistory {
  @HiveField(0)
  List<String> diseases;
  @HiveField(1)
  List<String> surgeries;
  @HiveField(2)
  List<String> familyHistory;

  PreviousHistory({
    required this.diseases,
    required this.surgeries,
    required this.familyHistory,
  });
}