import 'dart:async';
import 'package:hive/hive.dart';
import 'package:nusantara_aset_app/core/database/file_helper.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';
import 'package:nusantara_aset_app/core/models/data_aset_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nusantara_aset_app/core/base/base_view_model.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class DataAsetViewModel extends BaseViewModel {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  File? imageFile;

  List<DataAsetModel> dataAsetList = [];
  List<DataAsetModel> dataAsetResult = [];

  @override
  Future<void> initModel() async {
    setLoading(true);
    await fetchDataAset();
    setLoading(false);
  }

  bool get isFormValid {
    return nameController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        imageFile != null;
  }

  void updateName(String value) {
    nameController.text = value;
    notifyListeners();
  }

  void updateLocation(String value) {
    locationController.text = value;
    notifyListeners();
  }

  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      notifyListeners();
    }
    return null;
  }

  Future<File?> cameraImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageFile = File(image.path);
      notifyListeners();
    }
    return null;
  }

  void searchDataAset(String query) {
    if (query.length < 3) {
      dataAsetResult = [];
    } else {
      dataAsetResult =
          dataAsetList.where((aset) {
            final nameLower = aset.name.toLowerCase();
            final searchLower = query.toLowerCase();
            return nameLower.contains(searchLower);
          }).toList();
    }
    notifyListeners();
  }

  Future<void> createDataAset() async {
    final box = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
    final String generatedId = 'DATAASET-${DateTime.now().millisecondsSinceEpoch}';
    final String imagePath = await FileHelper.saveImageToAppDirectory(imageFile!, 'DATA-ASET');
    final DataAsetModel dataAset = DataAsetModel(
      id: generatedId,
      name: nameController.text,
      location: locationController.text,
      createdAt: DateTime.now(),
      image: imagePath,
    );
    await box.put(dataAset.id, dataAset);
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

    if (data != null && data.image.isNotEmpty) {
      final fileNameToDelete = path.basename(data.image);
      final isUse = box.values.any(
        (item) => item.id != data.id && path.basename(item.image) == fileNameToDelete,
      );
      if (!isUse) {
        final dir = await FileHelper.getAppImageDirectory('DATA-ASET');
        final file = File('${dir.path}/$fileNameToDelete');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await box.delete(id);
    await fetchDataAset();
  }

  Future<void> deleteAndRefreshData(String asetId) async {
    final box = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
    final data = box.get(asetId);

    if (data != null && data.image.isNotEmpty) {
      final fileNameToDelete = path.basename(data.image);
      final isUse = box.values.any(
        (item) => item.id != data.id && path.basename(item.image) == fileNameToDelete,
      );
      if (!isUse) {
        final dir = await FileHelper.getAppImageDirectory('DATA-ASET');
        final file = File('${dir.path}/$fileNameToDelete');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await box.delete(asetId);
    await fetchDataAset();
    searchDataAset(searchController.text);
  }

  Future<void> updateDataAset(DataAsetModel aset, String name, String location) async {
    final box = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
    final updatedAset = DataAsetModel(
      id: aset.id,
      name: name,
      location: location,
      image: imageFile?.path ?? aset.image,
      createdAt: aset.createdAt,
    );

    await box.put(aset.id, updatedAset);
    await fetchDataAset();
  }

  Future<void> updateAndRefreshData(DataAsetModel aset, String name, String location) async {
    final box = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
    final updatedAset = DataAsetModel(
      id: aset.id,
      name: name,
      location: location,
      image: imageFile?.path ?? aset.image,
      createdAt: aset.createdAt,
    );
    await box.put(aset.id, updatedAset);
    await fetchDataAset();
    searchDataAset(searchController.text);
  }
}
