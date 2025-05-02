import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/ui/components/custom_image.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/data-aset/data_aset_view_model.dart';
import 'package:nusantara_aset_app/ui/widgets/select_image_upload.dart';

class AddDataAsetView extends StatelessWidget {
  const AddDataAsetView({super.key});

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
      padding: EdgeInsets.all(20),
      children: [
        CustomTextField(
          controller: model.nameController,
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
                  onGallerySelected: () => model.pickImage(),
                  onCameraSelected: () => model.cameraImage(),
                );
              },
            );
          },
        ),
        SizedBox(height: 24),
        CustomButton.filled(
          onPressed:
              model.isFormValid
                  ? () {
                    model.createDataAset();
                    Navigator.pop(context);
                  }
                  : null,
          label: 'Simpan',
        ),
      ],
    );
  }
}
