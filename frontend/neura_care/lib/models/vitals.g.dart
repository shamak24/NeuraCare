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
      bpHigh: fields[0] as int,
      bpLow: fields[1] as int,
      heartRate: fields[2] as int,
      sugarLevel: fields[3] as int,
      weight: fields[4] as double,
      cholesterol: fields[5] as int,
      activityLevel: fields[6] as String,
      gender: fields[7] as String,
      age: fields[8] as int,
      height: fields[9] as double,
      smoking: fields[10] as bool,
      drinking: fields[11] as bool,
      sleepHours: fields[12] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Vitals obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.bpHigh)
      ..writeByte(1)
      ..write(obj.bpLow)
      ..writeByte(2)
      ..write(obj.heartRate)
      ..writeByte(3)
      ..write(obj.sugarLevel)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.cholesterol)
      ..writeByte(6)
      ..write(obj.activityLevel)
      ..writeByte(7)
      ..write(obj.gender)
      ..writeByte(8)
      ..write(obj.age)
      ..writeByte(9)
      ..write(obj.height)
      ..writeByte(10)
      ..write(obj.smoking)
      ..writeByte(11)
      ..write(obj.drinking)
      ..writeByte(12)
      ..write(obj.sleepHours);
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
