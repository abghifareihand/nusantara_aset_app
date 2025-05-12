import 'package:hive/hive.dart';

part 'tools_model.g.dart';

@HiveType(typeId: 5)
class ToolsModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<ListToolsModel> listTools;

  @HiveField(2)
  final DateTime createdAt;

  ToolsModel({required this.id, required this.listTools, required this.createdAt});

  Map<String, dynamic> toJson() {
    return {'listTools': listTools, 'createdAt': createdAt.toIso8601String()};
  }
}

@HiveType(typeId: 6)
class ListToolsModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String condition;

  @HiveField(4)
  final DateTime createdAt;

  ListToolsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.condition,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'condition': condition,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
