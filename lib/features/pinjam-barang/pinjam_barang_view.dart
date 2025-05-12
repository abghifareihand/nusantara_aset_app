import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/pinjam-barang/add-pinjam/add_pinjam_view.dart';
import 'package:nusantara_aset_app/features/pinjam-barang/edit-pinjam/edit_pinjam_view.dart';
import 'package:nusantara_aset_app/features/pinjam-barang/history-pinjam/history_pinjam_view.dart';
import 'package:nusantara_aset_app/features/pinjam-barang/pinjam_barang_view_model.dart';

class PinjamBarangView extends StatelessWidget {
  const PinjamBarangView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<PinjamBarangViewModel>(
      model: PinjamBarangViewModel(),
      onModelReady: (PinjamBarangViewModel model) => model.initModel(),
      onModelDispose: (PinjamBarangViewModel model) => model.disposeModel(),
      builder: (BuildContext context, PinjamBarangViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Peminjaman Barang'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PinjamBarangViewModel model) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        _buildCardItem(
          title: 'Dipinjam',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddPinjamView()));
          },
        ),
        const SizedBox(height: 16.0),
        _buildCardItem(
          title: 'Dikembalikan',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditPinjamView()));
          },
        ),
        const SizedBox(height: 16.0),
        _buildCardItem(
          title: 'History Pinjam',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPinjamView()));
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
