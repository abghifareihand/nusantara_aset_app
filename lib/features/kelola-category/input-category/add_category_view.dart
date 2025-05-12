import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/features/kelola-category/category_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/ui/widgets/select_image_upload.dart';

class AddCategoryView extends StatelessWidget {
  const AddCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryViewModel>(
      model: CategoryViewModel(),
      onModelReady: (CategoryViewModel model) {
        model.initModel();
        model.addListCategory();
      },
      onModelDispose: (CategoryViewModel model) => model.disposeModel(),
      builder: (BuildContext context, CategoryViewModel model, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Add Category List'), backgroundColor: Colors.blue),
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: model.pageController,
                  itemCount: model.nameListControllers.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryInputPage(context, model, index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    model.addListCategory(); // Tambah input baru
                    model.nextPage(); // Geser ke halaman berikutnya
                  },
                  child: const Text("Next"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    model.previousPage(); // Geser ke halaman berikutnya
                  },
                  child: const Text("Prev"),
                ),
              ),

              CustomButton.filled(
                onPressed: () {
                  model.createCategory();
                  Navigator.pop(context);
                },
                label: 'Simpan',
              ),
            ],
          ),
        );
      },
    );
  }

  // Membuat input kategori baru
  Widget _buildCategoryInputPage(BuildContext context, CategoryViewModel model, int index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: model.nameListControllers[index],
            label: 'Name List ${index + 1}',
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                ),
                builder: (context) {
                  return SelectImageUpload(
                    onGallerySelected: () => model.pickImageForList(index),
                    onCameraSelected: () => model.pickImageForList(index),
                  );
                },
              );
            },
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child:
                  model.imageListFiles[index] != null
                      ? Image.file(model.imageListFiles[index]!, fit: BoxFit.cover)
                      : const Center(child: Text('Pick Image')),
            ),
          ),
        ],
      ),
    );
  }
}
