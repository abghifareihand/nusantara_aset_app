import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/core/models/barang_masuk_model.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/transaksi_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';

class DetailBarangMasukView extends StatelessWidget {
  final BarangMasukModel barangMasuk;
  const DetailBarangMasukView({super.key, required this.barangMasuk});

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
            title: Text('Detail Barang Masuk'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, barangMasuk),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BarangMasukModel barangMasuk) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(barangMasuk.image),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Pengirim',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          Text(
            barangMasuk.pengirim,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.black),
          ),
          SizedBox(height: 16),
          Text(
            'Penerima',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          Text(
            barangMasuk.penerima,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.black),
          ),
          SizedBox(height: 16),
          Text(
            'Tanggal dan Waktu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          Text(
            barangMasuk.createdAt.toDateTimeFormatString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.black),
          ),
          SizedBox(height: 16),
          Text(
            'Keterangan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          Text(
            barangMasuk.keterangan,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
