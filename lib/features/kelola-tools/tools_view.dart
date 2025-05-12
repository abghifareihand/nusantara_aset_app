import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/kelola-tools/history-tools/history_tools_view.dart';
import 'package:nusantara_aset_app/features/kelola-tools/input-tools/input_tools_view.dart';
import 'package:nusantara_aset_app/features/kelola-tools/tools_view_model.dart';

class ToolsView extends StatelessWidget {
  const ToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ToolsViewModel>(
      model: ToolsViewModel(),
      onModelReady: (ToolsViewModel model) => model.initModel(),
      onModelDispose: (ToolsViewModel model) => model.disposeModel(),
      builder: (BuildContext context, ToolsViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text('Tools'), backgroundColor: AppColors.primary, elevation: 2),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ToolsViewModel model) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        _buildCardItem(
          title: 'Input Tools',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => InputToolsView()));
          },
        ),
        const SizedBox(height: 16.0),
        _buildCardItem(
          title: 'History Tools',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryToolsView()));
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
