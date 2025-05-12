import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/pinjam-barang/history-pinjam/detail_history_pinjam_view.dart';
import 'package:nusantara_aset_app/features/pinjam-barang/pinjam_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_dialog.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_pinjam.dart';

class HistoryPinjamView extends StatelessWidget {
  const HistoryPinjamView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<PinjamBarangViewModel>(
      model: PinjamBarangViewModel(),
      onModelReady: (model) => model.initModel(),
      onModelDispose: (model) => model.disposeModel(),
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('History Pinjam'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PinjamBarangViewModel model) {
    final filteredList =
        model.pinjamBarangList.where((item) => item.tanggalKembalikan != null).toList();

    if (filteredList.isEmpty) {
      return const Center(child: Text('Data Pinjam Kosong', style: TextStyle(fontSize: 16)));
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        model.fetchPinjamBarang();
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: filteredList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12.0),
        itemBuilder: (BuildContext context, int index) {
          final data = filteredList[index];
          return ItemCardPinjam(
            data: data,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailHistoryPinjamView(pinjamBarang: data),
                ),
              );
            },
            onLongPress: () {
              _showDeleteDialog(context, model, data.id);
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PinjamBarangViewModel model, String dataId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogDelete(
          title: 'Pinjam Barang',
          onPressedCancel: () {
            Navigator.pop(context);
          },
          onPressedDelete: () async {
            final navigator = Navigator.of(context);
            await model.deletePinjamBarang(dataId);
            navigator.pop();
          },
        );
      },
    );
  }
}
