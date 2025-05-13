import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/features/kelola-tools/tools_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/ui/components/custom_image.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/ui/widgets/select_image_upload.dart';

class InputToolsView extends StatelessWidget {
  const InputToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ToolsViewModel>(
      model: ToolsViewModel(),
      onModelReady: (ToolsViewModel model) => model.addListTools(),
      onModelDispose: (ToolsViewModel model) => model.disposeModel(),
      builder: (BuildContext context, ToolsViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Input Data Tools'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ToolsViewModel model) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: model.pageController,
            itemCount: model.nameListControllers.length,
            itemBuilder: (context, index) {
              return _buildListInputPage(context, model, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListInputPage(BuildContext context, ToolsViewModel model, int index) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        CustomTextField(
          controller: model.nameListControllers[index],
          label: 'Nama Tools ${index + 1}',
          onChanged: (value) => model.updateNameAtIndex(index, value),
        ),
        const SizedBox(height: 16),
        CustomImage(
          label: 'Foto Tools ${index + 1}',
          imageFile: model.imageListFiles[index],
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
              builder: (context) {
                return SelectImageUpload(
                  onGallerySelected: () => model.pickImageForList(index),
                  onCameraSelected: () => model.cameraImageForList(index),
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: model.conditionListControllers[index],
          label: 'Kondisi Tools ${index + 1}',
          onChanged: (value) => model.updateConditionAtIndex(index, value),
        ),
        const SizedBox(height: 24.0),
        Row(
          children: [
            if (model.currentIndex == 0)
              Expanded(
                child: CustomButton.filled(
                  onPressed:
                      model.isFormValid
                          ? () {
                            model.nextPage();
                          }
                          : null,
                  label: 'Add Tools',
                  fontSize: 14,
                  height: 42,
                  borderRadius: 10,
                ),
              )
            else ...[
              Expanded(
                child: CustomButton.outlined(
                  onPressed: model.previousPage,
                  label: 'Back',
                  fontSize: 14,
                  height: 42,
                  borderRadius: 10,
                ),
              ),
              const SizedBox(width: 24.0),
              Expanded(
                child: CustomButton.filled(
                  onPressed:
                      model.isFormValid
                          ? () {
                            model.nextPage();
                          }
                          : null,
                  label: 'Add Tools',
                  fontSize: 14,
                  height: 42,
                  borderRadius: 10,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 24.0),
        CustomButton.filled(
          onPressed:
              model.isFormValid
                  ? () {
                    model.createTools();
                    Navigator.pop(context);
                  }
                  : null,
          label: 'Simpan',
          fontSize: 14,
          height: 48,
          borderRadius: 12,
        ),
      ],
    );
  }
}
