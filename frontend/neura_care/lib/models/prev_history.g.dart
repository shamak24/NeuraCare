// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prev_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreviousHistoryAdapter extends TypeAdapter<PreviousHistory> {
  @override
  final int typeId = 3;

  @override
  PreviousHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreviousHistory(
      diseases: (fields[0] as List).cast<String>(),
      surgeries: (fields[1] as List).cast<String>(),
      familyHistory: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PreviousHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.diseases)
      ..writeByte(1)
      ..write(obj.surgeries)
      ..writeByte(2)
      ..write(obj.familyHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreviousHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
