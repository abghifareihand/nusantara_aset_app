import 'dart:async';

import 'package:hive/hive.dart';
import 'package:nusantara_aset_app/core/database/file_helper.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';
import 'package:nusantara_aset_app/core/models/data_aset_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nusantara_aset_app/core/base/base_view_model.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class DataAsetViewModel extends BaseViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  File? imageFile;
  String? imageName;
  Timer? _debounce;

  List<DataAsetModel> dataAsetList = [];
  List<DataAsetModel> searchResult = [];

  @override
  Future<void> initModel() async {
    setLoading(true);
    await fetchDataAset();
    setLoading(false);
  }

  bool get isFormValid {
    return nameController.text.isNotEmpty && imageFile != null;
  }

  void updateName(String value) {
    nameController.text = value;
    notifyListeners();
  }

  void updateDescription(String value) {
    descriptionController.text = value;
    notifyListeners();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      imageName = image.name;
      notifyListeners();
    }
  }

  Future<void> cameraImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageFile = File(image.path);
      imageName = image.name;
      notifyListeners();
    }
  }

  // void searchDataAset(String query) {
  //   if (query.isEmpty) {
  //     searchResult = [];
  //     notifyListeners();
  //     return;
  //   }

  //   searchResult =
  //       dataAsetList.where((aset) {
  //         final nameLower = aset.name.toLowerCase();
  //         final descLower = aset.description.toLowerCase();
  //         final searchLower = query.toLowerCase();

  //         return nameLower.contains(searchLower) || descLower.contains(searchLower);
  //       }).toList();

  //   notifyListeners();
  // }

  // Fungsi debouncer
  void searchDataAset(String query) {
    // Batalkan timer lama jika ada
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Set timer untuk mencari setelah 1 detik (bisa disesuaikan)
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (query.isEmpty) {
        searchResult = [];
      } else {
        searchResult =
            dataAsetList.where((aset) {
              final nameLower = aset.name.toLowerCase();
              final searchLower = query.toLowerCase();

              return nameLower.contains(searchLower);
            }).toList();
      }
      notifyListeners();
    });
  }

  Future<void> createDataAset() async {
    final box = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
    final String generatedId = 'DATAASET-${DateTime.now().millisecondsSinceEpoch}';
    final String imagePath = await FileHelper.saveImageToAppDirectory(imageFile!, 'DATA-ASET');
    final String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now());
    final DataAsetModel dataAset = DataAsetModel(
      id: generatedId,
      name: nameController.text,
      createdAt: formattedDate,
      image: imagePath,
    );
    await box.put(dataAset.id, dataAset);

    // Refresh data
    await fetchDataAset();
  }

  Future<void> fetchDataAset() async {
    final box = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
    dataAsetList = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteDataAset(String id) async {
    final box = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
    final data = box.get(id);

    // Hapus file jika ada
    if (data != null && data.image.isNotEmpty) {
      final file = File(data.image);
      if (await file.exists()) {
        await file.delete();
      }
    }

    // Hapus data dari Hive
    await box.delete(id);

    // Refresh data
    await fetchDataAset();
  }
}
