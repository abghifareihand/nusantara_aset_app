import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';

import 'package:nusantara_aset_app/features/kelola-category/category_view_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';

class HistoryCategoryView extends StatelessWidget {
  const HistoryCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryViewModel>(
      model: CategoryViewModel(),
      onModelReady: (model) => model.initModel(),
      onModelDispose: (model) => model.disposeModel(),
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('History Tools'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CategoryViewModel model) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: model.categoryList.length,
      itemBuilder: (context, index) {
        final category = model.categoryList[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ExpansionTile(
            title: Text('${category.nameCategory} (${category.listCategory.length})'),
            subtitle: Text('Created on: ${category.createdAt.toDateTimeFormatString()}'),
            children:
                category.listCategory.map((listCategory) {
                  return ListTile(
                    title: Text(listCategory.name),
                    subtitle: Image.file(File(listCategory.image)),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
