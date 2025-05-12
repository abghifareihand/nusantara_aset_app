import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/barang-keluar/barang_keluar_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/barang-masuk/barang_masuk_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/history-barang/history_barang_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/transaksi_barang_view_model.dart';

class TransaksiBarangView extends StatelessWidget {
  const TransaksiBarangView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<TransaksiBarangViewModel>(
      model: TransaksiBarangViewModel(),
      onModelReady: (TransaksiBarangViewModel model) => model.initModel(),
      onModelDispose: (TransaksiBarangViewModel model) => model.disposeModel(),
      builder: (BuildContext context, TransaksiBarangViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Barang In/Out'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TransaksiBarangViewModel model) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        _buildCardItem(
          title: 'Barang Masuk',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BarangMasukView()));
          },
        ),
        const SizedBox(height: 16.0),
        _buildCardItem(
          title: 'Barang Keluar',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BarangKeluarView()));
          },
        ),
        const SizedBox(height: 16.0),
        _buildCardItem(
          title: 'History Barang',
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryBarangView()));
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
