import 'package:hive/hive.dart';

part 'pinjam_barang_model.g.dart';

@HiveType(typeId: 4)
class PinjamBarangModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String peminjam;

  @HiveField(2)
  final String penanggungJawab;

  @HiveField(3)
  final String imagePeminjaman;

  @HiveField(4)
  final DateTime tanggalPeminjaman;

  @HiveField(5)
  final String? imageKembalikan;

  @HiveField(6)
  final DateTime? tanggalKembalikan;

  @HiveField(7)
  final String keterangan;

  PinjamBarangModel({
    required this.id,
    required this.peminjam,
    required this.penanggungJawab,
    required this.imagePeminjaman,
    required this.tanggalPeminjaman,
    this.imageKembalikan,
    this.tanggalKembalikan,
    required this.keterangan,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peminjam': peminjam,
      'penanggungJawab': penanggungJawab,
      'imagePeminjaman': imagePeminjaman,
      'tanggalPeminjaman': tanggalPeminjaman.toIso8601String(),
      'imageKembalikan': imageKembalikan,
      'tanggalKembalikan': tanggalKembalikan?.toIso8601String(),
      'keterangan': keterangan,
    };
  }
}
