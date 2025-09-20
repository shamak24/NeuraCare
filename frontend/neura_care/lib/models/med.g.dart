// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedAdapter extends TypeAdapter<Med> {
  @override
  final int typeId = 7;

  @override
  Med read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Med(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
      fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Med obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.medName)
      ..writeByte(1)
      ..write(obj.timingHrs)
      ..writeByte(2)
      ..write(obj.timingMins)
      ..writeByte(3)
      ..write(obj.number);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
