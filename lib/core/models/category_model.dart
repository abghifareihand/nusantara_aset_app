import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 7)
class CategoryModel {
  @HiveField(0)
  final String nameCategory;

  @HiveField(1)
  final List<ListCategoryModel> listCategory;

  @HiveField(2)
  final DateTime createdAt;

  CategoryModel({required this.nameCategory, required this.listCategory, required this.createdAt});
}

@HiveType(typeId: 8)
class ListCategoryModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String image;

  ListCategoryModel({required this.name, required this.image});
}
