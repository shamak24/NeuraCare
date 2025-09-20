// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_meals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyMealsAdapter extends TypeAdapter<DailyMeals> {
  @override
  final int typeId = 4;

  @override
  DailyMeals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyMeals(
      breakfast: fields[0] as Meal,
      lunch: fields[1] as Meal,
      dinner: fields[2] as Meal,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyMeals obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.breakfast)
      ..writeByte(1)
      ..write(obj.lunch)
      ..writeByte(2)
      ..write(obj.dinner)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyMealsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
