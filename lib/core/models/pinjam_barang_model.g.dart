// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinjam_barang_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PinjamBarangModelAdapter extends TypeAdapter<PinjamBarangModel> {
  @override
  final int typeId = 4;

  @override
  PinjamBarangModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PinjamBarangModel(
      id: fields[0] as String,
      peminjam: fields[1] as String,
      penanggungJawab: fields[2] as String,
      imagePeminjaman: fields[3] as String,
      tanggalPeminjaman: fields[4] as DateTime,
      imageKembalikan: fields[5] as String?,
      tanggalKembalikan: fields[6] as DateTime?,
      keterangan: fields[7] as String,
      durasi: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PinjamBarangModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.peminjam)
      ..writeByte(2)
      ..write(obj.penanggungJawab)
      ..writeByte(3)
      ..write(obj.imagePeminjaman)
      ..writeByte(4)
      ..write(obj.tanggalPeminjaman)
      ..writeByte(5)
      ..write(obj.imageKembalikan)
      ..writeByte(6)
      ..write(obj.tanggalKembalikan)
      ..writeByte(7)
      ..write(obj.keterangan)
      ..writeByte(8)
      ..write(obj.durasi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PinjamBarangModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
