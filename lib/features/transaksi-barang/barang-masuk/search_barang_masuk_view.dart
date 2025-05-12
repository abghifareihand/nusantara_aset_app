import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/barang-masuk/detail_barang_masuk_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/transaksi_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_dialog.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_barang_masuk.dart';

class SearchBarangMasukView extends StatelessWidget {
  const SearchBarangMasukView({super.key});

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
            title: Text('Cari Barang Masuk'),
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
        model.fetchBarangMasuk();
      },
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          CustomTextField(
            showLabel: false,
            controller: model.searchInController,
            textInputAction: TextInputAction.search,
            label: 'pengirim barang masuk...',
            onChanged: (value) => model.searchBarangMasuk(value),
            prefixIcon: Icon(Icons.search, color: AppColors.primary),
            focusNode: model.searchInFocusNode,
          ),
          const SizedBox(height: 24.0),
          if (model.searchInController.text.isEmpty)
            Center(
              child: Text(
                'Silakan ketik pengirim untuk mencari barang masuk.',
                style: TextStyle(color: AppColors.dark, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          else if (model.barangMasukResult.isEmpty)
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
            itemCount: model.barangMasukResult.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              final data = model.barangMasukResult[index];
              return ItemCardBarangMasuk(
                data: data,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBarangMasukView(barangMasuk: data),
                    ),
                  );
                },
                onLongPress: () {
                  _showDeleteInDialog(context, model, data.id);
                },
              );
            },
          ),
        ],
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
            await model.deleteBarangMasukAndRefreshData(dataId);
            navigator.pop();
          },
        );
      },
    );
  }
}
