import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/models/data_aset_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/ui/components/custom_dialog.dart';
import 'package:nusantara_aset_app/ui/components/custom_image.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/data-aset/data_aset_view_model.dart';
import 'package:nusantara_aset_app/features/data-aset/detail-data-aset/detail_data_aset_view.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_aset.dart';
import 'package:nusantara_aset_app/ui/widgets/select_image_upload.dart';

class SearchDataAsetView extends StatelessWidget {
  const SearchDataAsetView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<DataAsetViewModel>(
      model: DataAsetViewModel(),
      onModelReady: (DataAsetViewModel model) {
        model.initModel();
        model.searchFocusNode.requestFocus();
      },
      onModelDispose: (DataAsetViewModel model) => model.disposeModel(),
      builder: (BuildContext context, DataAsetViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Cari Data Aset'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DataAsetViewModel model) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        model.fetchDataAset();
      },
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          CustomTextField(
            showLabel: false,
            controller: model.searchController,
            textInputAction: TextInputAction.search,
            label: 'data aset...',
            onChanged: (value) => model.searchDataAset(value),
            prefixIcon: Icon(Icons.search, color: AppColors.primary),
            focusNode: model.searchFocusNode,
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
          else if (model.dataAsetResult.isEmpty)
            Center(
              child: Text(
                'Data tidak ditemukan.',
                style: TextStyle(color: AppColors.dark, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.dataAsetResult.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemBuilder: (BuildContext context, int index) {
              final aset = model.dataAsetResult[index];
              return ItemCardAset(
                data: aset,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailDataAsetView(aset: aset)),
                  );
                },
                onDelete: () {
                  _showDeleteDialog(context, model, aset.id);
                },
                onEdit: () {
                  _showEditSheet(context, model, aset);
                },
              );
            },
          ),
        ],
      ),
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
            await model.deleteAndRefreshData(asetId);
            navigator.pop();
          },
        );
      },
    );
  }

  void _showEditSheet(BuildContext context, DataAsetViewModel model, DataAsetModel aset) {
    final nameController = TextEditingController(text: aset.name);
    final locationController = TextEditingController(text: aset.location);
    model.imageFile = File(aset.image);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 24.0),
                      CustomTextField(
                        controller: nameController,
                        label: 'Nama',
                        onChanged: (value) => model.updateName(value),
                      ),
                      const SizedBox(height: 16.0),
                      CustomImage(
                        label: 'Foto',
                        imageFile: model.imageFile,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                            ),
                            builder: (context) {
                              return SelectImageUpload(
                                onGallerySelected: () async {
                                  File? selectedImage = await model.pickImage();
                                  if (selectedImage != null) {
                                    model.imageFile = selectedImage;
                                  }
                                  setState(() {});
                                },
                                onCameraSelected: () async {
                                  File? selectedImage = await model.cameraImage();
                                  if (selectedImage != null) {
                                    model.imageFile = selectedImage;
                                  }
                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextField(
                        controller: locationController,
                        label: 'Lokasi',
                        onChanged: (value) => model.updateLocation(value),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton.outlined(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              label: 'Batal',
                            ),
                          ),
                          const SizedBox(width: 24.0),
                          Expanded(
                            child: CustomButton.filled(
                              onPressed: () async {
                                final navigator = Navigator.of(context);
                                await model.updateAndRefreshData(
                                  aset,
                                  nameController.text,
                                  locationController.text,
                                );
                                navigator.pop();
                              },
                              label: 'Edit',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
