import 'package:hive/hive.dart';

part 'data_aset_model.g.dart';

@HiveType(typeId: 1)
class DataAsetModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String createdAt;

  DataAsetModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image, 'createdAt': createdAt};
  }
}
