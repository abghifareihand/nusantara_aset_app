import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/ui/components/custom_dialog.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/data-aset/add-data-aset/add_data_aset_view.dart';
import 'package:nusantara_aset_app/features/data-aset/data_aset_view_model.dart';
import 'package:nusantara_aset_app/features/data-aset/detail-data-aset/detail_data_aset_view.dart';
import 'package:nusantara_aset_app/features/data-aset/search-data-aset/search_data_aset_view.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_aset.dart';

class DataAsetView extends StatelessWidget {
  const DataAsetView({super.key});

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
            title: Text('Data Aset'),
            backgroundColor: AppColors.primary,
            elevation: 2,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchDataAsetView()),
                  );
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),

          body: _buildBody(context, model),
          floatingActionButton: _buildFloatingButton(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DataAsetViewModel model) {
    if (model.dataAsetList.isEmpty) {
      return const Center(child: Text('Data Aset Kosong', style: TextStyle(fontSize: 16)));
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        model.fetchDataAset();
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: model.dataAsetList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12.0),
        itemBuilder: (BuildContext context, int index) {
          final aset = model.dataAsetList[index];
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
    );
  }

  Widget _buildFloatingButton(BuildContext context, DataAsetViewModel model) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => AddDataAsetView()));
        model.fetchDataAset();
      },

      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add),
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
