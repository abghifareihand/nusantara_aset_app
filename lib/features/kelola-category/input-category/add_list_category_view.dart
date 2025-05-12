import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/features/kelola-category/category_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';

class AddListPage extends StatelessWidget {
  const AddListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<CategoryViewModel>(
      model: CategoryViewModel(),
      onModelReady: (CategoryViewModel model) => model.addListCategory(),
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
                    return _buildCategoryInputPage(model, index);
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
                  child: const Text("Add List & Next"),
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
  Widget _buildCategoryInputPage(CategoryViewModel model, int index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: model.nameListControllers[index],
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => model.pickImageForList(index),
            child: Container(
              height: 200,
              color: Colors.grey[200],
              child:
                  model.imageListFiles[index] == null
                      ? const Center(child: Text("Pick Image"))
                      : Image.file(model.imageListFiles[index]!, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
