// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barang_masuk_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarangMasukModelAdapter extends TypeAdapter<BarangMasukModel> {
  @override
  final int typeId = 2;

  @override
  BarangMasukModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarangMasukModel(
      id: fields[0] as String,
      pengirim: fields[1] as String,
      penerima: fields[2] as String,
      image: fields[3] as String,
      keterangan: fields[4] as String,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BarangMasukModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pengirim)
      ..writeByte(2)
      ..write(obj.penerima)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.keterangan)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarangMasukModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
