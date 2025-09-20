
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

  factory PreviousHistory.empty() {
    return PreviousHistory(
      diseases: [],
      surgeries: [],
      familyHistory: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseases': diseases,
      'surgeries': surgeries,
      'familyHistory': familyHistory,
    };
  }
  factory PreviousHistory.fromJson(Map<String, dynamic> json) {
    return PreviousHistory(
      diseases: List<String>.from(json['diseases'] ?? []),
      surgeries: List<String>.from(json['surgeries'] ?? []),
      familyHistory: List<String>.from(json['familyHistory'] ?? []),
    );
  }

  PreviousHistory copyWith({
    List<String>? diseases,
    List<String>? surgeries,
    List<String>? familyHistory,
  }) {
    return PreviousHistory(
      diseases: diseases ?? this.diseases,
      surgeries: surgeries ?? this.surgeries,
      familyHistory: familyHistory ?? this.familyHistory,
    );
  }

  @override
  String toString() {
    return 'PreviousHistory(diseases: $diseases, surgeries: $surgeries, familyHistory: $familyHistory)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PreviousHistory &&
        other.diseases.length == diseases.length &&
        other.surgeries.length == surgeries.length &&
        other.familyHistory.length == familyHistory.length &&
        List.generate(diseases.length, (index) => other.diseases[index] == diseases[index])
            .every((element) => element) &&
        List.generate(surgeries.length, (index) => other.surgeries[index] == surgeries[index])
            .every((element) => element) &&
        List.generate(familyHistory.length, (index) => other.familyHistory[index] == familyHistory[index])
            .every((element) => element);
  }
  @override
  int get hashCode => diseases.hashCode ^ surgeries.hashCode ^ familyHistory.hashCode;
}