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
      cuisinePreferences: (fields[5] as List).cast<CuisineType>(),
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
      ..write(obj.cuisinePreferences)
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

class CuisineTypeAdapter extends TypeAdapter<CuisineType> {
  @override
  final int typeId = 5;

  @override
  CuisineType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CuisineType.North;
      case 1:
        return CuisineType.South;
      case 2:
        return CuisineType.Indian;
      case 3:
        return CuisineType.Mexican;
      case 4:
        return CuisineType.Italian;
      case 5:
        return CuisineType.West;
      case 6:
        return CuisineType.Continental;
      default:
        return CuisineType.North;
    }
  }

  @override
  void write(BinaryWriter writer, CuisineType obj) {
    switch (obj) {
      case CuisineType.North:
        writer.writeByte(0);
        break;
      case CuisineType.South:
        writer.writeByte(1);
        break;
      case CuisineType.Indian:
        writer.writeByte(2);
        break;
      case CuisineType.Mexican:
        writer.writeByte(3);
        break;
      case CuisineType.Italian:
        writer.writeByte(4);
        break;
      case CuisineType.West:
        writer.writeByte(5);
        break;
      case CuisineType.Continental:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CuisineTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
