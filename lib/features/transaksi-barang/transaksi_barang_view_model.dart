import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nusantara_aset_app/core/base/base_view_model.dart';
import 'package:nusantara_aset_app/core/database/file_helper.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';
import 'package:nusantara_aset_app/core/models/barang_keluar_model.dart';
import 'package:nusantara_aset_app/core/models/barang_masuk_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';
import 'package:path/path.dart' as path;

class TransaksiBarangViewModel extends BaseViewModel {
  // Barang Masuk
  final TextEditingController pengirimInController = TextEditingController();
  final TextEditingController penerimaInController = TextEditingController();
  final TextEditingController datetimeInController = TextEditingController();
  final TextEditingController keteranganInController = TextEditingController();
  final TextEditingController searchInController = TextEditingController();
  final FocusNode searchInFocusNode = FocusNode();
  List<BarangMasukModel> barangMasukList = [];
  List<BarangMasukModel> barangMasukResult = [];

  // Barang Keluar
  final TextEditingController pengirimOutController = TextEditingController();
  final TextEditingController tujuanOutController = TextEditingController();
  final TextEditingController keteranganOutController = TextEditingController();
  final TextEditingController datetimeOutController = TextEditingController();
  final TextEditingController searchOutController = TextEditingController();
  final FocusNode searchOutFocusNode = FocusNode();
  List<BarangKeluarModel> barangKeluarList = [];
  List<BarangKeluarModel> barangKeluarResult = [];

  File? imageInFile;
  File? imageOutFile;

  @override
  Future<void> initModel() async {
    setLoading(true);
    await fetchBarangMasuk();
    await fetchBarangKeluar();
    setLoading(false);
  }

  // Barang Masuk
  bool get isFormValidIn {
    return pengirimInController.text.isNotEmpty &&
        penerimaInController.text.isNotEmpty &&
        datetimeInController.text.isNotEmpty &&
        keteranganInController.text.isNotEmpty &&
        imageInFile != null;
  }

  void searchBarangMasuk(String query) {
    if (query.length < 3) {
      barangMasukResult = [];
    } else {
      barangMasukResult =
          barangMasukList.where((data) {
            final nameLower = data.pengirim.toLowerCase();
            final searchLower = query.toLowerCase();
            return nameLower.contains(searchLower);
          }).toList();
    }
    notifyListeners();
  }

  Future<void> pickImageIn() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageInFile = File(image.path);
      notifyListeners();
    }
  }

  Future<void> cameraImageIn() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageInFile = File(image.path);
      notifyListeners();
    }
  }

  void updatePengirimIn(String value) {
    pengirimInController.text = value;
    notifyListeners();
  }

  void updatePenerimaIn(String value) {
    penerimaInController.text = value;
    notifyListeners();
  }

  void updateKeteranganIn(String value) {
    keteranganInController.text = value;
    notifyListeners();
  }

  void updateDateTimeIn(String value) {
    datetimeInController.text = value;
    notifyListeners();
  }

  Future<void> createBarangMasuk() async {
    final box = Hive.box<BarangMasukModel>(HiveHelper.barangMasukBox);
    final String generatedId = 'BARANGMASUK-${DateTime.now().millisecondsSinceEpoch}';
    final String imagePath = await FileHelper.saveImageToAppDirectory(imageInFile!, 'BARANG-MASUK');
    final BarangMasukModel barangMasuk = BarangMasukModel(
      id: generatedId,
      pengirim: pengirimInController.text,
      penerima: penerimaInController.text,
      image: imagePath,
      keterangan: keteranganInController.text,
      createdAt: datetimeInController.text.toParsedDateTime(),
    );
    await box.put(barangMasuk.id, barangMasuk);
  }

  Future<void> fetchBarangMasuk() async {
    final box = Hive.box<BarangMasukModel>(HiveHelper.barangMasukBox);
    barangMasukList = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteBarangMasuk(String id) async {
    final box = Hive.box<BarangMasukModel>(HiveHelper.barangMasukBox);
    final data = box.get(id);

    if (data != null && data.image.isNotEmpty) {
      final fileNameToDelete = path.basename(data.image);
      final isUse = box.values.any(
        (item) => item.id != data.id && path.basename(item.image) == fileNameToDelete,
      );
      if (!isUse) {
        final dir = await FileHelper.getAppImageDirectory('BARANG-MASUK');
        final file = File('${dir.path}/$fileNameToDelete');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await box.delete(id);
    await fetchBarangMasuk();
  }

  Future<void> deleteBarangMasukAndRefreshData(String id) async {
    final box = Hive.box<BarangMasukModel>(HiveHelper.barangMasukBox);
    final data = box.get(id);

    if (data != null && data.image.isNotEmpty) {
      final fileNameToDelete = path.basename(data.image);
      final isUse = box.values.any(
        (item) => item.id != data.id && path.basename(item.image) == fileNameToDelete,
      );
      if (!isUse) {
        final dir = await FileHelper.getAppImageDirectory('BARANG-MASUK');
        final file = File('${dir.path}/$fileNameToDelete');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await box.delete(id);
    await fetchBarangMasuk();
    searchBarangMasuk(searchInController.text);
  }

  // Barang Keluar
  bool get isFormValidOut {
    return pengirimOutController.text.isNotEmpty &&
        tujuanOutController.text.isNotEmpty &&
        datetimeOutController.text.isNotEmpty &&
        keteranganOutController.text.isNotEmpty &&
        imageOutFile != null;
  }

  void searchBarangKeluar(String query) {
    if (query.length < 3) {
      barangKeluarResult = [];
    } else {
      barangKeluarResult =
          barangKeluarList.where((data) {
            final nameLower = data.pengirim.toLowerCase();
            final searchLower = query.toLowerCase();
            return nameLower.contains(searchLower);
          }).toList();
    }
    notifyListeners();
  }

  Future<void> pickImageOut() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageOutFile = File(image.path);
      notifyListeners();
    }
  }

  Future<void> cameraImageOut() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageOutFile = File(image.path);
      notifyListeners();
    }
  }

  void updatePengirimOut(String value) {
    pengirimOutController.text = value;
    notifyListeners();
  }

  void updateTujuanOut(String value) {
    tujuanOutController.text = value;
    notifyListeners();
  }

  void updateKeteranganOut(String value) {
    keteranganOutController.text = value;
    notifyListeners();
  }

  void updateDateTimeOut(String value) {
    datetimeOutController.text = value;
    notifyListeners();
  }

  Future<void> createBarangKeluar() async {
    final box = Hive.box<BarangKeluarModel>(HiveHelper.barangKeluarBox);
    final String generatedId = 'BARANGKELUAR-${DateTime.now().millisecondsSinceEpoch}';
    final String imagePath = await FileHelper.saveImageToAppDirectory(
      imageOutFile!,
      'BARANG-KELUAR',
    );
    final BarangKeluarModel barangKeluar = BarangKeluarModel(
      id: generatedId,
      pengirim: pengirimOutController.text,
      tujuan: tujuanOutController.text,
      image: imagePath,
      keterangan: keteranganOutController.text,
      createdAt: datetimeOutController.text.toParsedDateTime(),
    );
    await box.put(barangKeluar.id, barangKeluar);
  }

  Future<void> fetchBarangKeluar() async {
    final box = Hive.box<BarangKeluarModel>(HiveHelper.barangKeluarBox);
    barangKeluarList = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteBarangKeluar(String id) async {
    final box = Hive.box<BarangKeluarModel>(HiveHelper.barangKeluarBox);
    final data = box.get(id);

    if (data != null && data.image.isNotEmpty) {
      final fileNameToDelete = path.basename(data.image);
      final isUse = box.values.any(
        (item) => item.id != data.id && path.basename(item.image) == fileNameToDelete,
      );
      if (!isUse) {
        final dir = await FileHelper.getAppImageDirectory('BARANG-KELUAR');
        final file = File('${dir.path}/$fileNameToDelete');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await box.delete(id);
    await fetchBarangKeluar();
  }

  Future<void> deleteBarangKeluarAndRefreshData(String id) async {
    final box = Hive.box<BarangKeluarModel>(HiveHelper.barangKeluarBox);
    final data = box.get(id);

    if (data != null && data.image.isNotEmpty) {
      final fileNameToDelete = path.basename(data.image);
      final isUse = box.values.any(
        (item) => item.id != data.id && path.basename(item.image) == fileNameToDelete,
      );
      if (!isUse) {
        final dir = await FileHelper.getAppImageDirectory('BARANG-KELUAR');
        final file = File('${dir.path}/$fileNameToDelete');
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    await box.delete(id);
    await fetchBarangKeluar();
    searchBarangKeluar(searchOutController.text);
  }

  String? startDate;
  String? endDate;
  String? dateRange;

  void setDateRange(DateTime start, DateTime end) {
    startDate = start.toIso8601String();
    endDate = end.toIso8601String();
    final formatter = DateFormat('dd/MM/yyyy');
    dateRange = '${formatter.format(start)} - ${formatter.format(end)}';
    notifyListeners();
  }

  DateTime? get selectedStartDate => startDate != null ? DateTime.parse(startDate!) : null;
  DateTime? get selectedEndDate => endDate != null ? DateTime.parse(endDate!) : null;

  String get displayDateRange {
    if (dateRange != null) {
      return dateRange!;
    } else {
      final now = DateTime.now();
      return DateFormat('dd/MM/yyyy').format(now);
    }
  }
}
