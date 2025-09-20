// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedListAdapter extends TypeAdapter<MedList> {
  @override
  final int typeId = 8;

  @override
  MedList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedList(
      meds: (fields[0] as List).cast<Med>(),
    );
  }

  @override
  void write(BinaryWriter writer, MedList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.meds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
