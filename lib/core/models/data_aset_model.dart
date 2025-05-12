import 'package:hive/hive.dart';

part 'data_aset_model.g.dart';

@HiveType(typeId: 3)
class DataAsetModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final DateTime createdAt;

  DataAsetModel({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
