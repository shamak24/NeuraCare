// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DietAdapter extends TypeAdapter<Diet> {
  @override
  final int typeId = 2;

  @override
  Diet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Diet(
      vegan: fields[0] as bool,
      vegetarian: fields[1] as bool,
      glutenFree: fields[2] as bool,
      lactoseFree: fields[3] as bool,
      keto: fields[4] as bool,
      cuisinePreference: (fields[5] as List).cast<CuisineType>(),
      allergies: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Diet obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.vegan)
      ..writeByte(1)
      ..write(obj.vegetarian)
      ..writeByte(2)
      ..write(obj.glutenFree)
      ..writeByte(3)
      ..write(obj.lactoseFree)
      ..writeByte(4)
      ..write(obj.keto)
      ..writeByte(5)
      ..write(obj.cuisinePreference)
      ..writeByte(6)
      ..write(obj.allergies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
