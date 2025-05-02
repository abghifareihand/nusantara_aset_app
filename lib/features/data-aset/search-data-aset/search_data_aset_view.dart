import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/ui/components/custom_dialog.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/data-aset/data_aset_view_model.dart';
import 'package:nusantara_aset_app/features/data-aset/detail-data-aset/detail_data_aset_view.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_aset.dart';

class SearchDataAsetView extends StatelessWidget {
  const SearchDataAsetView({super.key});

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
            title: Text('Buat Data Aset'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DataAsetViewModel model) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        CustomTextField(
          showLabel: false,
          controller: model.searchController,
          label: 'Cari data aset...',
          onChanged: (value) => model.searchDataAset(value),
          prefixIcon: Icon(Icons.search, color: AppColors.primary),
        ),
        const SizedBox(height: 24.0),
        if (model.searchController.text.isEmpty)
          Center(
            child: Text(
              'Silakan ketik untuk mencari data aset.',
              style: TextStyle(color: AppColors.dark, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        // Kondisi ketika hasil pencarian tidak ditemukan
        else if (model.searchResult.isEmpty)
          Center(
            child: Text(
              'Data tidak ditemukan.',
              style: TextStyle(color: AppColors.dark, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

        // Kondisi ketika hasil pencarian ditemukan
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: model.searchResult.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12.0),
          itemBuilder: (BuildContext context, int index) {
            final aset = model.searchResult[index];
            return ItemCardAset(
              name: aset.name,
              image: aset.image,
              createdAt: aset.createdAt,
              index: index,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailDataAsetView(dataAset: aset)),
                );
              },
              onLongPress: () {
                _showDeleteDialog(context, model, aset.id);
              },
            );
          },
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, DataAsetViewModel model, String asetId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogDelete(
          title: 'Data Aset',
          onPressedCancel: () {
            Navigator.pop(context);
          },
          onPressedDelete: () async {
            final navigator = Navigator.of(context);
            await model.deleteDataAset(asetId);
            navigator.pop();
          },
        );
      },
    );
  }
}
