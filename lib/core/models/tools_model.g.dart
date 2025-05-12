// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tools_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToolsModelAdapter extends TypeAdapter<ToolsModel> {
  @override
  final int typeId = 5;

  @override
  ToolsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToolsModel(
      id: fields[0] as String,
      listTools: (fields[1] as List).cast<ListToolsModel>(),
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ToolsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.listTools)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToolsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListToolsModelAdapter extends TypeAdapter<ListToolsModel> {
  @override
  final int typeId = 6;

  @override
  ListToolsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListToolsModel(
      id: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
      condition: fields[3] as String,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ListToolsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.condition)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListToolsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
