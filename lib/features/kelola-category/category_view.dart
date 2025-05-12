import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/kelola-category/category_view_model.dart';
import 'package:nusantara_aset_app/features/kelola-category/history-category/history_category_view.dart';
import 'package:nusantara_aset_app/features/kelola-category/input-category/add_category_view.dart';
import 'package:nusantara_aset_app/features/kelola-category/input-category/input_category_view.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryViewModel>(
      model: CategoryViewModel(),
      onModelReady: (CategoryViewModel model) => model.initModel(),
      onModelDispose: (CategoryViewModel model) => model.disposeModel(),
      builder: (BuildContext context, CategoryViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text('Tools'), backgroundColor: AppColors.primary, elevation: 2),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CategoryViewModel model) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        _buildCardItem(
          title: 'Input Category',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => InputCategoryView()));
            // Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategoryView()));
          },
        ),
        const SizedBox(height: 16.0),
        _buildCardItem(
          title: 'History Category',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryCategoryView()));
          },
        ),
      ],
    );
  }

  Widget _buildCardItem({required String title, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
