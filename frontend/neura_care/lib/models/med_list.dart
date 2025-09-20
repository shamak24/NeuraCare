import 'package:hive_flutter/hive_flutter.dart';
import 'package:neura_care/models/med.dart';

part 'med_list.g.dart';

@HiveType(typeId: 8)
class MedList {
  @HiveField(0)
  List<Med> meds;

  MedList({required this.meds});

  factory MedList.fromJson(Map<String, dynamic> json) {
    var medsFromJson = json['meds'] as List;
    List<Med> medList = medsFromJson.map((med) => Med.fromJson(med)).toList();
    return MedList(meds: medList);
  }

  Map<String, dynamic> toJson() {
    return {
      'meds': meds.map((med) => med.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'MedList(meds: )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedList && other.meds == meds;
  }

  @override
  int get hashCode => meds.hashCode;
}
