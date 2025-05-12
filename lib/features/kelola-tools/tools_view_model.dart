import 'dart:io';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nusantara_aset_app/core/database/file_helper.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';
import 'package:nusantara_aset_app/core/models/tools_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:nusantara_aset_app/core/base/base_view_model.dart';

class ToolsViewModel extends BaseViewModel {
  final PageController pageController = PageController();

  List<TextEditingController> nameListControllers = [];
  List<TextEditingController> conditionListControllers = [];
  List<File?> imageListFiles = [];
  List<ToolsModel> toolsList = [];
  int currentIndex = 0;
  Set<int> expandedIndexes = {};

  @override
  Future<void> initModel() async {
    setLoading(true);
    await fetchTools();
    setLoading(false);
  }

  bool get isFormValid {
    if (nameListControllers.length != imageListFiles.length ||
        nameListControllers.length != conditionListControllers.length) {
      return false;
    }

    // Cek hanya untuk halaman yang sedang aktif
    final currentIndexValid =
        nameListControllers[currentIndex].text.isNotEmpty &&
        conditionListControllers[currentIndex].text.isNotEmpty &&
        imageListFiles[currentIndex] != null;

    return currentIndexValid;
  }

  void toggleExpanded(int index) {
    if (expandedIndexes.contains(index)) {
      expandedIndexes.remove(index);
    } else {
      expandedIndexes.add(index);
    }
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
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageListFiles[index] = File(image.path);
      notifyListeners();
    }
  }

  void nextPage() {
    if (currentIndex < nameListControllers.length - 1) {
      currentIndex++;
    } else {
      addListTools();
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

  void addListTools() {
    nameListControllers.add(TextEditingController());
    conditionListControllers.add(TextEditingController());
    imageListFiles.add(null);
    notifyListeners();
  }

  void updateNameAtIndex(int index, String value) {
    if (index >= 0 && index < nameListControllers.length) {
      nameListControllers[index].text = value;
      notifyListeners();
    }
  }

  void updateConditionAtIndex(int index, String value) {
    if (index >= 0 && index < conditionListControllers.length) {
      conditionListControllers[index].text = value;
      notifyListeners();
    }
  }

  Future<void> fetchTools() async {
    final box = Hive.box<ToolsModel>(HiveHelper.toolsBox);
    toolsList = box.values.toList();
    notifyListeners();
  }

  Future<void> createTools() async {
    final box = Hive.box<ToolsModel>(HiveHelper.toolsBox);
    final String generatedId = 'TOOLS-${DateTime.now().millisecondsSinceEpoch}';
    final DateTime now = DateTime.now(); // Generate time once

    final ToolsModel tools = ToolsModel(
      id: generatedId,
      listTools: await _generateListTools(now),
      createdAt: now, // Use the same time here
    );

    await box.put(generatedId, tools);
    await fetchTools();
  }

  Future<List<ListToolsModel>> _generateListTools(DateTime now) async {
    List<ListToolsModel> listTools = [];
    final String generatedId = 'TOOLS-${DateTime.now().millisecondsSinceEpoch}';
    for (int i = 0; i < nameListControllers.length; i++) {
      final name = nameListControllers[i].text;
      final condition = conditionListControllers[i].text;
      final image = imageListFiles[i];
      if (name.isNotEmpty && image != null) {
        final String listCategoryImagePath = await FileHelper.saveImageToAppDirectory(
          image,
          'LIST-TOOLS',
        );
        listTools.add(
          ListToolsModel(
            id: generatedId,
            name: name,
            image: listCategoryImagePath,
            condition: condition,
            createdAt: now, // Pass the same time here
          ),
        );
      }
    }
    return listTools;
  }

  Future<void> deleteToolsData(String id) async {
    final box = Hive.box<ToolsModel>(HiveHelper.toolsBox);
    final data = box.get(id);

    if (data != null && data.listTools.isNotEmpty) {
      for (final tool in data.listTools) {
        if (tool.image.isNotEmpty) {
          final fileNameToDelete = path.basename(tool.image);

          // Cek apakah file ini digunakan oleh item lain
          final isUsedElsewhere = box.values.any((item) {
            if (item.id == data.id) return false;
            return item.listTools.any(
              (listTool) => path.basename(listTool.image) == fileNameToDelete,
            );
          });

          // Jika tidak digunakan di item lain, hapus filenya
          if (!isUsedElsewhere) {
            final dir = await FileHelper.getAppImageDirectory('TOOLS');
            final file = File('${dir.path}/$fileNameToDelete');
            if (await file.exists()) {
              await file.delete();
            }
          }
        }
      }
    }

    await box.delete(id);
    await fetchTools();
  }

  Future<void> deleteToolsListItem({required String parentId, required int itemIndex}) async {
    final box = Hive.box<ToolsModel>(HiveHelper.toolsBox);
    final parentData = box.get(parentId);

    if (parentData == null || itemIndex < 0 || itemIndex >= parentData.listTools.length) return;

    final toolToDelete = parentData.listTools[itemIndex];
    final fileNameToDelete = path.basename(toolToDelete.image);

    // Cek apakah file digunakan di item lain
    final isUsedElsewhere = box.values.any((item) {
      if (item == parentData) return false;
      return item.listTools.any((listTool) => path.basename(listTool.image) == fileNameToDelete);
    });

    // Hapus gambar jika tidak digunakan di item lain
    if (!isUsedElsewhere && toolToDelete.image.isNotEmpty) {
      final dir = await FileHelper.getAppImageDirectory('TOOLS');
      final file = File('${dir.path}/$fileNameToDelete');
      if (await file.exists()) {
        await file.delete();
      }
    }

    // Jika hanya ada 1 item, hapus seluruh parentData
    if (parentData.listTools.length == 1) {
      await box.delete(parentId);
    } else {
      // Hapus item dari list dan update parentData
      final updatedList = List<ListToolsModel>.from(parentData.listTools)..removeAt(itemIndex);
      final updatedModel = ToolsModel(
        id: parentData.id,
        listTools: updatedList,
        createdAt: parentData.createdAt,
      );
      await box.put(parentId, updatedModel);
    }

    await fetchTools();
  }
}
