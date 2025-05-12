import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/barang-keluar/detail_barang_keluar_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/transaksi_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_dialog.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_barang_keluar.dart';

class SearchBarangKeluarView extends StatelessWidget {
  const SearchBarangKeluarView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<TransaksiBarangViewModel>(
      model: TransaksiBarangViewModel(),
      onModelReady: (TransaksiBarangViewModel model) {
        model.initModel();
        model.searchInFocusNode.requestFocus();
      },
      onModelDispose: (TransaksiBarangViewModel model) => model.disposeModel(),
      builder: (BuildContext context, TransaksiBarangViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Cari Barang Keluar'),
            backgroundColor: AppColors.primary,
            elevation: 2,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
            ),
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TransaksiBarangViewModel model) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        model.fetchBarangKeluar();
      },
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          CustomTextField(
            showLabel: false,
            controller: model.searchOutController,
            textInputAction: TextInputAction.search,
            label: 'pengirim barang keluar...',
            onChanged: (value) => model.searchBarangKeluar(value),
            prefixIcon: Icon(Icons.search, color: AppColors.primary),
            focusNode: model.searchOutFocusNode,
          ),
          const SizedBox(height: 24.0),
          if (model.searchOutController.text.isEmpty)
            Center(
              child: Text(
                'Silakan ketik pengirim untuk mencari barang keluar.',
                style: TextStyle(color: AppColors.dark, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          else if (model.barangKeluarResult.isEmpty)
            Center(
              child: Text(
                'Data pengirim tidak ditemukan.',
                style: TextStyle(color: AppColors.dark, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.barangKeluarResult.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              final data = model.barangKeluarResult[index];
              return ItemCardBarangKeluar(
                data: data,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBarangKeluarView(barangKeluar: data),
                    ),
                  );
                },
                onLongPress: () {
                  _showDeleteOutDialog(context, model, data.id);
                },
              );
            },
          ),
        ],
      ),
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
            await model.deleteBarangKeluarAndRefreshData(dataId);
            navigator.pop();
          },
        );
      },
    );
  }
}
