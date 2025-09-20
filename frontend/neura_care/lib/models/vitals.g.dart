// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VitalsAdapter extends TypeAdapter<Vitals> {
  @override
  final int typeId = 1;

  @override
  Vitals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vitals(
      bloodPressure: fields[0] as double,
      heartRate: fields[1] as int,
      sugarLevel: fields[2] as double,
      weight: fields[3] as double,
      cholesterol: fields[4] as double,
      activityLevel: fields[5] as String,
      gender: fields[6] as String,
      age: fields[7] as int,
      height: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Vitals obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.bloodPressure)
      ..writeByte(1)
      ..write(obj.heartRate)
      ..writeByte(2)
      ..write(obj.sugarLevel)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.cholesterol)
      ..writeByte(5)
      ..write(obj.activityLevel)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.age)
      ..writeByte(8)
      ..write(obj.height);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VitalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
