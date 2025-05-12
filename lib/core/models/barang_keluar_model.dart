import 'package:hive/hive.dart';

part 'barang_keluar_model.g.dart';

@HiveType(typeId: 1)
class BarangKeluarModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String pengirim;

  @HiveField(2)
  final String tujuan;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final String keterangan;

  @HiveField(5)
  final DateTime createdAt;

  BarangKeluarModel({
    required this.id,
    required this.pengirim,
    required this.tujuan,
    required this.image,
    required this.keterangan,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'pengirim': pengirim,
      'tujuan': tujuan,
      'image': image,
      'keterangan': keterangan,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
