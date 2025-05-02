// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_aset_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataAsetModelAdapter extends TypeAdapter<DataAsetModel> {
  @override
  final int typeId = 1;

  @override
  DataAsetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataAsetModel(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
      createdAt: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DataAsetModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAsetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
