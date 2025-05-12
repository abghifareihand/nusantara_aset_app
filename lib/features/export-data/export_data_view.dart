import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/core/database/export_helper.dart';
import 'package:nusantara_aset_app/features/export-data/export_data_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';

class ExportDataView extends StatelessWidget {
  const ExportDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ExportDataViewModel>(
      model: ExportDataViewModel(),
      onModelReady: (ExportDataViewModel model) => model.initModel(),
      onModelDispose: (ExportDataViewModel model) => model.disposeModel(),
      builder: (BuildContext context, ExportDataViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Export Data'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ExportDataViewModel model) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        _buildButtonExport(
          title: 'Export Data Aset',
          onPressed: () async {
            await ExportHelper.exportDataAset(
              onError: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
              },
              onSuccess: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
              },
            );
          },
        ),
        const SizedBox(height: 16.0),
        _buildButtonExport(
          title: 'Export Barang Masuk',
          onPressed: () async {
            await ExportHelper.exportBarangMasuk(
              onError: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
              },
              onSuccess: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
              },
            );
          },
        ),
        const SizedBox(height: 16.0),
        _buildButtonExport(
          title: 'Export Barang Keluar',
          onPressed: () async {
            await ExportHelper.exportBarangKeluar(
              onError: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
              },
              onSuccess: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
              },
            );
          },
        ),
        const SizedBox(height: 16.0),
        _buildButtonExport(
          title: 'Export Pinjam Barang',
          onPressed: () async {
            await ExportHelper.exportPinjamBarang(
              onError: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
              },
              onSuccess: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
              },
            );
          },
        ),
        const SizedBox(height: 16.0),
        _buildButtonExport(
          title: 'Export Tools',
          onPressed: () async {
            await ExportHelper.exportTools(
              onError: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
              },
              onSuccess: (message) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
              },
            );
          },
        ),

        // ElevatedButton.icon(
        //   onPressed: () async {
        //     await model.exportBarangMasuk();
        //     if (!context.mounted) return;
        //     _showDone(context, 'Barang Masuk');
        //   },
        //   icon: Icon(Icons.file_download),
        //   label: Text('Export Barang Masuk'),
        // ),
        // ElevatedButton.icon(
        //   onPressed: () async {
        //     await model.exportBarangKeluar();
        //     if (!context.mounted) return;
        //     _showDone(context, 'Barang Keluar');
        //   },
        //   icon: Icon(Icons.file_download),
        //   label: Text('Export Barang Keluar'),
        // ),
        // ElevatedButton.icon(
        //   onPressed: () async {
        //     await model.exportPinjamBarang();
        //     if (!context.mounted) return;
        //     _showDone(context, 'Pinjam Barang');
        //   },
        //   icon: Icon(Icons.file_download),
        //   label: Text('Export Pinjam Barang'),
        // ),
      ],
    );
  }

  Widget _buildButtonExport({required String title, required VoidCallback onPressed}) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        icon: Icon(Icons.file_download),
        label: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
