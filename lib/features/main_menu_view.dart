import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/data-aset/data_aset_view.dart';
import 'package:nusantara_aset_app/features/main_menu_view_model.dart';

class MainMenuView extends StatelessWidget {
  const MainMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<MainMenuViewModel>(
      model: MainMenuViewModel(),
      onModelReady: (MainMenuViewModel model) => model.initModel(),
      onModelDispose: (MainMenuViewModel model) => model.disposeModel(),
      builder: (BuildContext context, MainMenuViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Nusantara Aset'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, MainMenuViewModel model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 60.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCardItem(
                title: 'Data Aset',
                icon: Icons.inventory,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DataAsetView()));
                },
              ),
              const SizedBox(width: 40.0),
              _buildCardItem(
                title: 'Barang In/Out',
                icon: Icons.swap_horiz,
                onTap: () {
                  /// assa
                },
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCardItem(
                title: 'Pinjam Barang',
                icon: Icons.access_time,
                onTap: () {
                  /// assa
                },
              ),
              const SizedBox(width: 40.0),
              _buildCardItem(
                title: 'Tools',
                icon: Icons.build,
                onTap: () {
                  /// assa
                },
              ),
            ],
          ),
          const SizedBox(height: 40.0),
          _buildCardItem(
            title: 'Export',
            icon: Icons.file_download,
            onTap: () {
              /// assa
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w700, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
