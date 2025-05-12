import 'dart:developer';
import 'dart:io';
import 'package:nusantara_aset_app/core/database/file_helper.dart';
import 'package:nusantara_aset_app/core/models/category_model.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nusantara_aset_app/core/base/base_view_model.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';

class CategoryViewModel extends BaseViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  List<CategoryModel> categoryList = [];
  File? imageFile;

  List<TextEditingController> nameListControllers = [];
  List<File?> imageListFiles = [];

  final PageController pageController = PageController();

  // Index untuk menentukan halaman yang aktif
  int currentIndex = 0;

  void nextPage() {
    // Jika masih ada halaman berikutnya, cukup geser halaman
    if (currentIndex < nameListControllers.length - 1) {
      currentIndex++;
    } else {
      // Kalau di halaman terakhir, tambahkan field baru
      addListCategory();
      currentIndex++;
    }

    pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void previousPage() {
    // Jika masih ada halaman sebelumnya (bukan halaman pertama),
    if (currentIndex > 0) {
      currentIndex--;
      pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  // @override
  // void disposeModel() {
  //   pageController.dispose();
  //   super.dispose();
  // }

  bool get isFormValidList {
    if (nameListControllers.length != imageListFiles.length) return false;

    final allNamesFilled = nameListControllers.every((controller) => controller.text.isNotEmpty);
    final allImagesSelected = imageListFiles.every((file) => file != null);

    return allNamesFilled && allImagesSelected;
  }

  void updateNameAtIndex(int index, String value) {
    if (index >= 0 && index < nameListControllers.length) {
      nameListControllers[index].text = value;
      notifyListeners();
    }
  }

  // Add new empty list input
  void addListCategory() {
    nameListControllers.add(TextEditingController());
    imageListFiles.add(null);
    notifyListeners();
  }

  // Remove input field if needed
  void removeListCategory(int index) {
    nameListControllers.removeAt(index);
    imageListFiles.removeAt(index);
    notifyListeners();
  }

  Future<void> pickImageForList(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageListFiles[index] = File(image.path);
      notifyListeners();
    }
  }

  Future<void> cameraImageForList(int index) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageListFiles[index] = File(image.path);
      notifyListeners();
    }
  }

  // Future<void> createDataAset() async {
  //   final box = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
  //   final String generatedId = 'DATAASET-${DateTime.now().millisecondsSinceEpoch}';
  //   final String imagePath = await FileHelper.saveImageToAppDirectory(imageFile!, 'DATA-ASET');
  //   final DataAsetModel dataAset = DataAsetModel(
  //     id: generatedId,
  //     name: nameController.text,
  //     location: locationController.text,
  //     createdAt: DateTime.now(),
  //     image: imagePath,
  //   );
  //   await box.put(dataAset.id, dataAset);
  //   await fetchDataAset();
  // }

  Future<void> fetchCategory() async {
    final box = Hive.box<CategoryModel>(HiveHelper.categoryBox);
    categoryList = box.values.toList(); // Mengambil semua kategori dari Hive

    log('Fetched Category List: $categoryList');
    notifyListeners(); // Memperbarui tampilan
  }

  Future<void> createCategory() async {
    final box = Hive.box<CategoryModel>(HiveHelper.categoryBox);

    // Generate ID untuk Category
    final String generatedId = 'CATEGORY-${DateTime.now().millisecondsSinceEpoch}';

    // Membuat kategori
    final CategoryModel category = CategoryModel(
      // nameCategory: nameController.text,
      nameCategory: 'CATEGORY-${DateTime.now().millisecondsSinceEpoch}',
      listCategory: await _generateListCategory(), // Await here since it's async
      createdAt: DateTime.now(),
    );

    // Simpan kategori ke Hive
    await box.put(generatedId, category);

    // Fetch kategori untuk menampilkan data terbaru
    await fetchCategory();
  }

  Future<List<ListCategoryModel>> _generateListCategory() async {
    List<ListCategoryModel> listCategory = [];

    for (int i = 0; i < nameListControllers.length; i++) {
      final name = nameListControllers[i].text;
      final image = imageListFiles[i];

      if (name.isNotEmpty && image != null) {
        // Simpan gambar untuk setiap list kategori
        final String listCategoryImagePath = await FileHelper.saveImageToAppDirectory(
          image,
          'LIST-CATEGORY-$i',
        );

        // Menambahkan ke list
        listCategory.add(ListCategoryModel(name: name, image: listCategoryImagePath));
      }
    }
    return listCategory;
  }

  @override
  Future<void> initModel() async {
    setLoading(true);
    await fetchCategory();
    setLoading(false);
  }

  bool get isFormValid {
    return nameController.text.isNotEmpty &&
        conditionController.text.isNotEmpty &&
        imageFile != null;
  }

  // ---------- Image Handling ----------
  Future<void> pickImageCategory() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      notifyListeners();
    }
  }

  Future<void> cameraImageCategory() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageFile = File(image.path);
      notifyListeners();
    }
  }

  // ---------- Form Update ----------
  void updateName(String value) {
    nameController.text = value;
    notifyListeners();
  }

  void updateCondition(String value) {
    conditionController.text = value;
    notifyListeners();
  }

  // ---------- Category Data ----------
  // Future<void> fetchCategory() async {
  //   final box = Hive.box<CategoryModel>(HiveHelper.toolsBox);
  //   categoryList = box.values.toList();

  //   log('Fetched Category List : $categoryList');
  //   notifyListeners();
  // }
}
