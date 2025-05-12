import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/core/models/data_aset_model.dart';
import 'package:nusantara_aset_app/features/data-aset/data_aset_view_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';

class DetailDataAsetView extends StatelessWidget {
  final DataAsetModel aset;
  const DetailDataAsetView({super.key, required this.aset});

  @override
  Widget build(BuildContext context) {
    return BaseView<DataAsetViewModel>(
      model: DataAsetViewModel(),
      onModelReady: (DataAsetViewModel model) => model.initModel(),
      onModelDispose: (DataAsetViewModel model) => model.disposeModel(),
      builder: (BuildContext context, DataAsetViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Detail Data Aset'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, aset),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DataAsetModel aset) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(aset.image),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Nama Aset',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          Text(
            aset.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.black),
          ),
          SizedBox(height: 16),
          Text(
            'Tanggal dan Waktu',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          Text(
            aset.createdAt.toDateTimeFormatString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.black),
          ),
          SizedBox(height: 16),
          Text(
            'Lokasi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
          ),
          Text(
            aset.location,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
