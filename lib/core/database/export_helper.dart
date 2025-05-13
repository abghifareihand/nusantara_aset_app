import 'dart:io';
import 'dart:math';
import 'dart:developer' as print;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';
import 'package:nusantara_aset_app/core/models/tools_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../models/barang_keluar_model.dart';
import '../models/barang_masuk_model.dart';
import '../models/data_aset_model.dart';
import '../models/pinjam_barang_model.dart';

class ExportHelper {
  static Future<void> exportDataAset({
    required Function(String) onError,
    required Function(String) onSuccess,
  }) async {
    try {
      final box = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
      if (box.isEmpty) {
        onError('Belum ada data aset untuk diexport');
        return;
      }

      final workbook = Workbook();
      await _addSheetWithImage<DataAsetModel>(
        workbook: workbook,
        sheetName: 'DataAset',
        headers: ['NO', 'Nama', 'Lokasi', 'Tanggal'],
        items: box.values.toList(),
        rowMapper:
            (list) =>
                list
                    .asMap()
                    .entries
                    .map(
                      (entry) => [
                        (entry.key + 1).toString(),
                        entry.value.name,
                        entry.value.location,
                        entry.value.createdAt.toDateTimeFormatString(),
                      ],
                    )
                    .toList(),
        imagePathGetter: (e) => e.image,
        imageHeaderName: 'Foto Aset',
      );
      await _saveWorkbook(workbook, 'data_aset');

      onSuccess('Export data aset berhasil!');
    } catch (e) {
      onError('Terjadi kesalahan saat mengekspor data aset: $e');
    }
  }

  static Future<void> exportBarangMasuk({
    required Function(String) onError,
    required Function(String) onSuccess,
  }) async {
    try {
      final box = Hive.box<BarangMasukModel>(HiveHelper.barangMasukBox);
      if (box.isEmpty) {
        onError('Belum ada data barang masuk untuk diexport');
        return;
      }

      final workbook = Workbook();
      await _addSheetWithImage<BarangMasukModel>(
        workbook: workbook,
        sheetName: 'BarangMasuk',
        headers: ['NO', 'Pengirim', 'Penerima', 'Keterangan', 'Tanggal'],
        items: box.values.toList(),
        rowMapper:
            (list) =>
                list
                    .asMap()
                    .entries
                    .map(
                      (entry) => [
                        (entry.key + 1).toString(),
                        entry.value.pengirim,
                        entry.value.penerima,
                        entry.value.keterangan,
                        entry.value.createdAt.toDateTimeFormatString(),
                      ],
                    )
                    .toList(),
        imagePathGetter: (e) => e.image,
        imageHeaderName: 'Foto',
      );

      await _saveWorkbook(workbook, 'barang_masuk');
      onSuccess('Export barang masuk berhasil!');
    } catch (e) {
      onError('Terjadi kesalahan saat mengekspor barang masuk: $e');
    }
  }

  static Future<void> exportBarangKeluar({
    required Function(String) onError,
    required Function(String) onSuccess,
  }) async {
    try {
      final box = Hive.box<BarangKeluarModel>(HiveHelper.barangKeluarBox);
      if (box.isEmpty) {
        onError('Belum ada data barang keluar untuk diexport');
        return;
      }

      final workbook = Workbook();
      await _addSheetWithImage<BarangKeluarModel>(
        workbook: workbook,
        sheetName: 'BarangKeluar',
        headers: ['NO', 'Pengirim', 'Tujuan', 'Keterangan', 'Tanggal'],
        items: box.values.toList(),
        rowMapper:
            (list) =>
                list
                    .asMap()
                    .entries
                    .map(
                      (entry) => [
                        (entry.key + 1).toString(),
                        entry.value.pengirim,
                        entry.value.tujuan,
                        entry.value.keterangan,
                        entry.value.createdAt.toDateTimeFormatString(),
                      ],
                    )
                    .toList(),
        imagePathGetter: (e) => e.image,
        imageHeaderName: 'Foto',
      );

      await _saveWorkbook(workbook, 'barang_keluar');
      onSuccess('Export barang keluar berhasil!');
    } catch (e) {
      onError('Terjadi kesalahan saat mengekspor barang keluar: $e');
    }
  }

  static Future<void> exportPinjamBarang({
    required Function(String) onError,
    required Function(String) onSuccess,
  }) async {
    try {
      final box = Hive.box<PinjamBarangModel>(HiveHelper.pinjamBarangBox);
      if (box.isEmpty) {
        onError('Belum ada data pinjam barang untuk diexport');
        return;
      }

      final belumDikembalikan = box.values.any((e) => e.tanggalKembalikan == null);
      if (belumDikembalikan) {
        onError('Ada barang yang belum di kembalikan');
        return;
      }

      final workbook = Workbook();
      await _addSheetWithMultiImages<PinjamBarangModel>(
        workbook: workbook,
        sheetName: 'PinjamBarang',
        headers: [
          'NO',
          'Peminjam',
          'Penanggung Jawab',
          'Keterangan',
          'Tanggal Peminjaman',
          'Tanggal Pengembalian',
        ],
        items: box.values.toList(),
        rowMapper:
            (list) =>
                list
                    .asMap()
                    .entries
                    .map(
                      (entry) => [
                        (entry.key + 1).toString(),
                        entry.value.peminjam,
                        entry.value.penanggungJawab,
                        entry.value.keterangan,
                        entry.value.tanggalPeminjaman.toDateTimeFormatString(),
                        entry.value.tanggalKembalikan?.toDateTimeFormatString() ?? '',
                      ],
                    )
                    .toList(),
        imagePinjamGetter: (e) => e.imagePeminjaman,
        imageKembaliGetter: (e) => e.imageKembalikan ?? e.imagePeminjaman,
        imagePinjamHeader: 'Foto',
        imageKembaliHeader: 'Foto',
      );

      await _saveWorkbook(workbook, 'pinjam_barang');
      onSuccess('Export pinjam barang berhasil!');
    } catch (e) {
      onError('Terjadi kesalahan saat mengekspor pinjam barang: $e');
    }
  }

  static Future<void> exportTools({
    required Function(String) onError,
    required Function(String) onSuccess,
  }) async {
    try {
      final box = Hive.box<ToolsModel>(HiveHelper.toolsBox);
      final allListTools = box.values.expand((tools) => tools.listTools).toList();

      if (allListTools.isEmpty) {
        onError('Belum ada tools untuk diexport');
        return;
      }

      final workbook = Workbook();
      await _addSheetWithImage<ListToolsModel>(
        workbook: workbook,
        sheetName: 'DataAset',
        headers: ['NO', 'Nama', 'Kondisi', 'Tanggal'],
        items: allListTools,
        rowMapper:
            (list) =>
                list
                    .asMap()
                    .entries
                    .map(
                      (entry) => [
                        (entry.key + 1).toString(),
                        entry.value.name,
                        entry.value.condition,
                        entry.value.createdAt.toDateTimeFormatString(),
                      ],
                    )
                    .toList(),
        imagePathGetter: (e) => e.image,
        imageHeaderName: 'Foto Tools',
      );
      await _saveWorkbook(workbook, 'tools');

      onSuccess('Export tools berhasil!');
    } catch (e) {
      onError('Terjadi kesalahan saat mengekspor tools: $e');
    }
  }

  // ✅ Fungsi umum untuk menambahkan sheet dengan gambar
  static Future<void> _addSheetWithImage<T>({
    required Workbook workbook,
    required String sheetName,
    required List<String> headers,
    required List<T> items,
    required List<List<String>> Function(List<T>) rowMapper,
    required String Function(T) imagePathGetter,
    required String imageHeaderName,
  }) async {
    // final Worksheet sheet = workbook.worksheets.addWithName(sheetName); // Sheet ke 2 with name
    final Worksheet sheet = workbook.worksheets[0];

    // Header
    for (int c = 0; c < headers.length; c++) {
      final cell = sheet.getRangeByIndex(1, c + 1);
      cell.setText(headers[c]);
      cell.cellStyle.bold = true;
      _addBorders(cell);
    }

    final imgHeaderCell = sheet.getRangeByIndex(1, headers.length + 1);
    imgHeaderCell.setText(imageHeaderName);
    imgHeaderCell.cellStyle.bold = true;
    _addBorders(imgHeaderCell);

    final rows = rowMapper(items);

    // Data
    for (int r = 0; r < rows.length; r++) {
      final rowIndex = r + 2;
      for (int c = 0; c < rows[r].length; c++) {
        final cell = sheet.getRangeByIndex(rowIndex, c + 1);
        cell.setText(rows[r][c]);
        cell.cellStyle.hAlign = HAlignType.center;
        cell.cellStyle.vAlign = VAlignType.center;
        _addBorders(cell);
      }

      final imgPath = imagePathGetter(items[r]);
      if (imgPath.isNotEmpty && File(imgPath).existsSync()) {
        final bytes = await File(imgPath).readAsBytes();
        final picture = sheet.pictures.addStream(rowIndex, headers.length + 1, bytes);
        picture.height = 75;
        picture.width = 75;
        sheet.getRangeByIndex(rowIndex, 1).rowHeight = 60;

        _addBorders(sheet.getRangeByIndex(rowIndex, headers.length + 1));
      }
    }

    for (int c = 0; c < headers.length; c++) {
      int maxLength = headers[c].length;
      for (int r = 0; r < rows.length; r++) {
        maxLength = max(maxLength, rows[r][c].length);
      }
      sheet.getRangeByIndex(1, c + 1).columnWidth = maxLength + 2;
    }

    if (items.isNotEmpty) {
      sheet.getRangeByIndex(2, headers.length + 1).rowHeight = 60;
      sheet.getRangeByIndex(1, headers.length + 1).columnWidth = 10;
    }
  }

  // ✅ Fungsi umum untuk menambahkan sheet dengan gambar lebih dari satu
  static Future<void> _addSheetWithMultiImages<T>({
    required Workbook workbook,
    required String sheetName,
    required List<String> headers,
    required List<T> items,
    required List<List<String>> Function(List<T>) rowMapper,
    required String Function(T) imagePinjamGetter,
    required String Function(T) imageKembaliGetter,
    required String imagePinjamHeader,
    required String imageKembaliHeader,
  }) async {
    // final Worksheet sheet = workbook.worksheets.addWithName(sheetName);
    final Worksheet sheet = workbook.worksheets[0];

    // Header
    for (int c = 0; c < headers.length; c++) {
      final cell = sheet.getRangeByIndex(1, c + 1);
      cell.setText(headers[c]);
      cell.cellStyle.bold = true;
      _addBorders(cell);
    }

    // Tambah header gambar pinjam dan gambar kembali
    final imgPinjamCell = sheet.getRangeByIndex(1, headers.length + 1);
    imgPinjamCell.setText(imagePinjamHeader);
    imgPinjamCell.cellStyle.bold = true;
    _addBorders(imgPinjamCell);

    final imgKembaliCell = sheet.getRangeByIndex(1, headers.length + 2);
    imgKembaliCell.setText(imageKembaliHeader);
    imgKembaliCell.cellStyle.bold = true;
    _addBorders(imgKembaliCell);

    final rows = rowMapper(items);

    // Data
    for (int r = 0; r < rows.length; r++) {
      final rowIndex = r + 2;

      for (int c = 0; c < rows[r].length; c++) {
        final cell = sheet.getRangeByIndex(rowIndex, c + 1);
        cell.setText(rows[r][c]);
        cell.cellStyle.hAlign = HAlignType.center;
        cell.cellStyle.vAlign = VAlignType.center;
        _addBorders(cell);
      }

      // Gambar Pinjam
      final imgPinjam = imagePinjamGetter(items[r]);
      if (imgPinjam.isNotEmpty && File(imgPinjam).existsSync()) {
        final bytes = await File(imgPinjam).readAsBytes();
        final picture = sheet.pictures.addStream(rowIndex, headers.length + 1, bytes);
        picture.height = 75;
        picture.width = 75;
        sheet.getRangeByIndex(rowIndex, 1).rowHeight = 60;
        _addBorders(sheet.getRangeByIndex(rowIndex, headers.length + 1));
      }

      // Gambar Kembali
      final imgKembali = imageKembaliGetter(items[r]);
      if (imgKembali.isNotEmpty && File(imgKembali).existsSync()) {
        final bytes = await File(imgKembali).readAsBytes();
        final picture = sheet.pictures.addStream(rowIndex, headers.length + 2, bytes);
        picture.height = 75;
        picture.width = 75;
        sheet.getRangeByIndex(rowIndex, 1).rowHeight = 60;
        _addBorders(sheet.getRangeByIndex(rowIndex, headers.length + 2));
      }
    }

    // Otomatis atur lebar kolom sesuai isi
    for (int c = 0; c < headers.length; c++) {
      int maxLength = headers[c].length;
      for (int r = 0; r < rows.length; r++) {
        maxLength = max(maxLength, rows[r][c].length);
      }
      sheet.getRangeByIndex(1, c + 1).columnWidth = maxLength + 2;
    }

    if (items.isNotEmpty) {
      sheet.getRangeByIndex(2, headers.length + 1).rowHeight = 60;
      sheet.getRangeByIndex(2, headers.length + 2).rowHeight = 60;
      sheet.getRangeByIndex(1, headers.length + 1).columnWidth = 10;
      sheet.getRangeByIndex(1, headers.length + 2).columnWidth = 10;
    }
  }

  // ✅ Fungsi utilitas untuk border
  static void _addBorders(Range cell) {
    cell.cellStyle.borders.top.lineStyle = LineStyle.thin;
    cell.cellStyle.borders.top.color = '#000000';
    cell.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
    cell.cellStyle.borders.bottom.color = '#000000';
    cell.cellStyle.borders.left.lineStyle = LineStyle.thin;
    cell.cellStyle.borders.left.color = '#000000';
    cell.cellStyle.borders.right.lineStyle = LineStyle.thin;
    cell.cellStyle.borders.right.color = '#000000';
  }

  static Future<void> _saveWorkbook(Workbook workbook, String prefix) async {
    final bytes = workbook.saveAsStream();
    workbook.dispose();

    final now = DateTime.now().toLocal();
    final fileName = '${prefix}_${DateFormat('ddMMyyHHmmss').format(now)}.xlsx';

    // Tentukan folder utama
    final mainDirectory = Directory('/storage/emulated/0/NUSANTARA_ASET');

    // Pastikan folder utama ada
    if (!await mainDirectory.exists()) {
      await mainDirectory.create(recursive: true);
    }

    // Tentukan folder berdasarkan prefix
    final folderDirectory = Directory('${mainDirectory.path}/$prefix');

    // Pastikan folder berdasarkan prefix ada
    if (!await folderDirectory.exists()) {
      await folderDirectory.create(recursive: true);
    }

    // Tentukan path lengkap file
    final file = File('${folderDirectory.path}/$fileName');

    await file.writeAsBytes(bytes, flush: true);

    print.log('Excel exported to: ${file.path}');
  }
}
