// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barang_keluar_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarangKeluarModelAdapter extends TypeAdapter<BarangKeluarModel> {
  @override
  final int typeId = 1;

  @override
  BarangKeluarModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarangKeluarModel(
      id: fields[0] as String,
      pengirim: fields[1] as String,
      tujuan: fields[2] as String,
      image: fields[3] as String,
      keterangan: fields[4] as String,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BarangKeluarModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pengirim)
      ..writeByte(2)
      ..write(obj.tujuan)
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
      other is BarangKeluarModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
