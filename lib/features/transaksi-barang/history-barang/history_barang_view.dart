import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/barang-keluar/detail_barang_keluar_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/barang-masuk/detail_barang_masuk_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/transaksi_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_dialog.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_barang_masuk.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_barang_keluar.dart';

class HistoryBarangView extends StatelessWidget {
  const HistoryBarangView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<TransaksiBarangViewModel>(
      model: TransaksiBarangViewModel(),
      onModelReady: (model) => model.initModel(),
      onModelDispose: (model) => model.disposeModel(),
      builder: (context, model, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('History Barang'),
              backgroundColor: AppColors.primary,
              elevation: 2,
              bottom: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.4), // warna teks tidak aktif
                tabs: [Tab(text: 'Masuk'), Tab(text: 'Keluar')],
              ),
            ),
            body: TabBarView(
              children: [_buildBarangMasuk(context, model), _buildBarangKeluar(context, model)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBarangMasuk(BuildContext context, TransaksiBarangViewModel model) {
    if (model.barangMasukList.isEmpty) {
      return const Center(child: Text('Data Barang Masuk Kosong', style: TextStyle(fontSize: 16)));
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        model.fetchBarangMasuk();
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: model.barangMasukList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12.0),
        itemBuilder: (context, index) {
          final data = model.barangMasukList[index];
          return ItemCardBarangMasuk(
            data: data,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailBarangMasukView(barangMasuk: data)),
              );
            },
            onLongPress: () {
              _showDeleteInDialog(context, model, data.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildBarangKeluar(BuildContext context, TransaksiBarangViewModel model) {
    if (model.barangKeluarList.isEmpty) {
      return const Center(child: Text('Data Barang Keluar Kosong', style: TextStyle(fontSize: 16)));
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        model.fetchBarangKeluar();
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: model.barangKeluarList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12.0),
        itemBuilder: (context, index) {
          final data = model.barangKeluarList[index];
          return ItemCardBarangKeluar(
            data: data,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailBarangKeluarView(barangKeluar: data)),
              );
            },
            onLongPress: () {
              _showDeleteOutDialog(context, model, data.id);
            },
          );
        },
      ),
    );
  }

  void _showDeleteInDialog(BuildContext context, TransaksiBarangViewModel model, String dataId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogDelete(
          title: 'Barang Masuk',
          onPressedCancel: () {
            Navigator.pop(context);
          },
          onPressedDelete: () async {
            final navigator = Navigator.of(context);
            await model.deleteBarangMasuk(dataId);
            navigator.pop();
          },
        );
      },
    );
  }

  void _showDeleteOutDialog(BuildContext context, TransaksiBarangViewModel model, String dataId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogDelete(
          title: 'Barang Keluar',
          onPressedCancel: () {
            Navigator.pop(context);
          },
          onPressedDelete: () async {
            final navigator = Navigator.of(context);
            await model.deleteBarangKeluar(dataId);
            navigator.pop();
          },
        );
      },
    );
  }
}
