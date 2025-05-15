import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nusantara_aset_app/core/base/base_view_model.dart';
import 'package:nusantara_aset_app/core/database/file_helper.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';
import 'package:nusantara_aset_app/core/models/pinjam_barang_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';

class PinjamBarangViewModel extends BaseViewModel {
  final TextEditingController peminjamController = TextEditingController();
  final TextEditingController penanggungController = TextEditingController();
  final TextEditingController datetimePeminjamanController = TextEditingController();
  final TextEditingController datetimeKembalikanController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  List<PinjamBarangModel> pinjamBarangList = [];

  File? imagePeminjamanFile;
  File? imageKembalikanFile;

  @override
  Future<void> initModel() async {
    setLoading(true);
    await fetchPinjamBarang();
    setLoading(false);
  }

  // Barang Masuk
  bool get isFormValidPinjam {
    return peminjamController.text.isNotEmpty &&
        penanggungController.text.isNotEmpty &&
        datetimePeminjamanController.text.isNotEmpty &&
        keteranganController.text.isNotEmpty &&
        imagePeminjamanFile != null;
  }

  Future<void> pickImagePeminjaman() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePeminjamanFile = File(image.path);
      notifyListeners();
    }
  }

  Future<void> cameraImagePeminjaman() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagePeminjamanFile = File(image.path);
      notifyListeners();
    }
  }

  Future<void> pickImageKembalikan() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageKembalikanFile = File(image.path);
      notifyListeners();
    }
  }

  Future<void> cameraImageKembalikan() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageKembalikanFile = File(image.path);
      notifyListeners();
    }
  }

  void updatePeminjam(String value) {
    peminjamController.text = value;
    notifyListeners();
  }

  void updatePenanggung(String value) {
    penanggungController.text = value;
    notifyListeners();
  }

  void updateDateTimePeminjaman(String value) {
    datetimePeminjamanController.text = value;
    notifyListeners();
  }

  void updateKeterangan(String value) {
    keteranganController.text = value;
    notifyListeners();
  }

  Future<void> createPinjamBarang() async {
    final box = Hive.box<PinjamBarangModel>(HiveHelper.pinjamBarangBox);
    final String generatedId = 'PINJAMBARANG-${DateTime.now().millisecondsSinceEpoch}';
    final String imagePath = await FileHelper.saveImageToAppDirectory(
      imagePeminjamanFile!,
      'PINJAM-BARANG',
    );
    final PinjamBarangModel pinjamBarang = PinjamBarangModel(
      id: generatedId,
      peminjam: peminjamController.text,
      penanggungJawab: penanggungController.text,
      imagePeminjaman: imagePath,
      tanggalPeminjaman: datetimePeminjamanController.text.toParsedDateTime(),
      keterangan: keteranganController.text,
    );
    await box.put(pinjamBarang.id, pinjamBarang);
  }

  Future<void> fetchPinjamBarang() async {
    final box = Hive.box<PinjamBarangModel>(HiveHelper.pinjamBarangBox);
    pinjamBarangList = box.values.toList();
    notifyListeners();
  }

  Future<void> deletePinjamBarang(String id) async {
    final box = Hive.box<PinjamBarangModel>(HiveHelper.pinjamBarangBox);
    final data = box.get(id);

    // Hapus file jika ada
    if (data != null && data.imagePeminjaman.isNotEmpty) {
      final file = File(data.imagePeminjaman);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await box.delete(id);
    await fetchPinjamBarang();
  }

  Future<void> updatePinjamBarang(String id) async {
    final box = Hive.box<PinjamBarangModel>(HiveHelper.pinjamBarangBox);
    final data = box.get(id);

    if (data != null &&
        imageKembalikanFile != null &&
        datetimeKembalikanController.text.isNotEmpty) {
      // Simpan foto pengembalian ke folder lokal
      final String imagePath = await FileHelper.saveImageToAppDirectory(
        imageKembalikanFile!,
        'PINJAM-BARANG',
      );

      // Konversi tanggal pengembalian dari controller
      final tanggalKembalikan = datetimeKembalikanController.text.toParsedDateTime();
      final tanggalPeminjaman = data.tanggalPeminjaman;

      // Hitung durasi peminjaman
      String durasiPeminjaman = '';
      final duration = tanggalKembalikan.difference(tanggalPeminjaman);
      final days = duration.inDays;
      final hours = duration.inHours % 24;
      final minutes = duration.inMinutes % 60;
      durasiPeminjaman = '$days hari $hours jam $minutes menit';

      // Buat data baru dengan image dan tanggal pengembalian
      final updated = PinjamBarangModel(
        id: data.id,
        peminjam: data.peminjam,
        penanggungJawab: data.penanggungJawab,
        imagePeminjaman: data.imagePeminjaman,
        tanggalPeminjaman: data.tanggalPeminjaman,
        imageKembalikan: imagePath,
        tanggalKembalikan: datetimeKembalikanController.text.toParsedDateTime(),
        keterangan: data.keterangan,
        durasi: durasiPeminjaman,
      );

      await box.put(id, updated);
      await fetchPinjamBarang(); // Refresh list
    }
  }
}
