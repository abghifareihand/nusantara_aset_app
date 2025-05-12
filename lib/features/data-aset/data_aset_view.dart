import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/models/data_aset_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/ui/components/custom_dialog.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/data-aset/add-data-aset/add_data_aset_view.dart';
import 'package:nusantara_aset_app/features/data-aset/data_aset_view_model.dart';
import 'package:nusantara_aset_app/features/data-aset/detail-data-aset/detail_data_aset_view.dart';
import 'package:nusantara_aset_app/features/data-aset/search-data-aset/search_data_aset_view.dart';
import 'package:nusantara_aset_app/ui/components/custom_image.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_aset.dart';
import 'package:nusantara_aset_app/ui/widgets/select_image_upload.dart';

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
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchDataAsetView()),
                  );
                  model.fetchDataAset();
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
                              onPressed: () {
                                model.updateDataAset(
                                  aset,
                                  nameController.text,
                                  locationController.text,
                                );
                                Navigator.pop(context);
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
