import 'package:hive/hive.dart';

part 'barang_masuk_model.g.dart';

@HiveType(typeId: 2)
class BarangMasukModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String pengirim;

  @HiveField(2)
  final String penerima;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final String keterangan;

  @HiveField(5)
  final DateTime createdAt;

  BarangMasukModel({
    required this.id,
    required this.pengirim,
    required this.penerima,
    required this.image,
    required this.keterangan,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'pengirim': pengirim,
      'penerima': penerima,
      'image': image,
      'keterangan': keterangan,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
