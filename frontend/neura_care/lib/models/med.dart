

import 'package:hive_flutter/hive_flutter.dart';
part 'med.g.dart';
@HiveType(typeId: 7)
class Med {

  @HiveField(0)
  final String medName;
  @HiveField(1)
  final int timingHrs;
  @HiveField(2)
  final int timingMins;
  @HiveField(3)
  final int number;
  const Med(
    this.medName,
    this.timingHrs,
    this.timingMins,
    this.number,
  );
  factory Med.empty() {
    return Med(
      '',
      0,
      0,
      0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'medName': medName,
      'timingHrs': timingHrs,
      'timingMins': timingMins,
      'number': number,
    };
  }

  factory Med.fromJson(Map<String, dynamic> json) {
    return Med(
      json['medName'] ?? '',
      json['timingHrs'] ?? 0,
      json['timingMins'] ?? 0,
      json['number'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Meds(medName: $medName, timing: $timingHrs:$timingMins, number: $number)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Med &&
        other.medName == medName &&
        other.timingHrs == timingHrs &&
        other.timingMins == timingMins &&
        other.number == number;
  }

  @override
  int get hashCode {
    return medName.hashCode ^ timingHrs.hashCode ^ timingMins.hashCode ^ number.hashCode;
  }
}
