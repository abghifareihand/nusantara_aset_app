// import 'dart:developer';
// import 'dart:io';
// import 'package:excel/excel.dart';
// import 'package:hive/hive.dart';
// import 'package:nusantara_aset_app/core/database/hive_helper.dart';
// import 'package:nusantara_aset_app/core/models/barang_keluar_model.dart';
// import 'package:nusantara_aset_app/core/models/barang_masuk_model.dart';
// import 'package:nusantara_aset_app/core/models/data_aset_model.dart';
// import 'package:nusantara_aset_app/core/models/pinjam_barang_model.dart';
// import 'package:intl/intl.dart';

// class ExportHelper {
//   static Future<void> exportAllBoxesToExcel() async {
//     final excel = Excel.createExcel();
//     final timestamp = DateTime.now().toLocal();
//     final fileName = '${DateFormat('ddMMyyHHmmss').format(timestamp)}_nusantara_aset.xlsx';
//     final dir = Directory('/storage/emulated/0/Download');
//     final outputFile = File('${dir.path}/$fileName');

//     try {
//       final dataAsetBox = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
//       final barangMasukBox = Hive.box<BarangMasukModel>(HiveHelper.barangMasukBox);
//       final barangKeluarBox = Hive.box<BarangKeluarModel>(HiveHelper.barangKeluarBox);
//       final pinjamBarangBox = Hive.box<PinjamBarangModel>(HiveHelper.pinjamBarangBox);

//       // common styles
//       final headerStyle = CellStyle(
//         bold: true,
//         backgroundColorHex: ExcelColor.amber,
//         topBorder: Border(borderStyle: BorderStyle.Thin),
//         bottomBorder: Border(borderStyle: BorderStyle.Thin),
//         leftBorder: Border(borderStyle: BorderStyle.Thin),
//         rightBorder: Border(borderStyle: BorderStyle.Thin),
//       );
//       final cellStyle = CellStyle(
//         topBorder: Border(borderStyle: BorderStyle.Thin),
//         bottomBorder: Border(borderStyle: BorderStyle.Thin),
//         leftBorder: Border(borderStyle: BorderStyle.Thin),
//         rightBorder: Border(borderStyle: BorderStyle.Thin),
//       );

//       void applyTableStyle(Sheet sheet, int rows, int cols) {
//         for (var r = 0; r < rows; r++) {
//           for (var c = 0; c < cols; c++) {
//             final idx = CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r);
//             sheet.cell(idx).cellStyle = (r == 0 ? headerStyle : cellStyle);
//           }
//         }
//       }

//       // Data Aset
//       final asetSheet = excel['DataAset'];
//       asetSheet.appendRow(
//         ['ID', 'Nama', 'Lokasi', 'Image URL', 'Created At'].map(TextCellValue.new).toList(),
//       );
//       for (var item in dataAsetBox.values) {
//         asetSheet.appendRow(
//           [
//             item.id,
//             item.name,
//             item.location,
//             item.image,
//             item.createdAt,
//           ].map(TextCellValue.new).toList(),
//         );
//       }
//       applyTableStyle(asetSheet, dataAsetBox.length + 1, 5);

//       // Barang Masuk
//       final masukSheet = excel['BarangMasuk'];
//       masukSheet.appendRow(
//         [
//           'ID',
//           'Pengirim',
//           'Penerima',
//           'Image Path',
//           'Keterangan',
//           'Created At',
//         ].map(TextCellValue.new).toList(),
//       );
//       for (var item in barangMasukBox.values) {
//         masukSheet.appendRow(
//           [
//             item.id,
//             item.pengirim,
//             item.penerima,
//             item.image,
//             item.keterangan,
//             item.createdAt,
//           ].map(TextCellValue.new).toList(),
//         );
//       }
//       applyTableStyle(masukSheet, barangMasukBox.length + 1, 6);

//       // Barang Keluar
//       final keluarSheet = excel['BarangKeluar'];
//       keluarSheet.appendRow(
//         [
//           'ID',
//           'Pengirim',
//           'Tujuan',
//           'Image Path',
//           'Keterangan',
//           'Created At',
//         ].map(TextCellValue.new).toList(),
//       );
//       for (var item in barangKeluarBox.values) {
//         keluarSheet.appendRow(
//           [
//             item.id,
//             item.pengirim,
//             item.tujuan,
//             item.image,
//             item.keterangan,
//             item.createdAt,
//           ].map(TextCellValue.new).toList(),
//         );
//       }
//       applyTableStyle(keluarSheet, barangKeluarBox.length + 1, 6);

//       // Pinjam Barang
//       final pinjamSheet = excel['PinjamBarang'];
//       pinjamSheet.appendRow(
//         [
//           'ID',
//           'Peminjam',
//           'Penanggung Jawab',
//           'Image Peminjaman',
//           'Tanggal Peminjaman',
//           'Image Kembalikan',
//           'Tanggal Kembalikan',
//           'Durasi',
//           'Keterangan',
//         ].map(TextCellValue.new).toList(),
//       );
//       for (var item in pinjamBarangBox.values) {
//         pinjamSheet.appendRow(
//           [
//             item.id,
//             item.peminjam,
//             item.penanggungJawab,
//             item.imagePeminjaman,
//             item.tanggalPeminjaman,
//             item.imageKembalikan ?? '',
//             item.tanggalKembalikan ?? '',
//             item.durasi,
//             item.keterangan,
//           ].map(TextCellValue.new).toList(),
//         );
//       }
//       applyTableStyle(pinjamSheet, pinjamBarangBox.length + 1, 9);

//       final bytes = excel.encode();
//       if (bytes != null) await outputFile.writeAsBytes(bytes, flush: true);
//       log('File disimpan: ${outputFile.path}');
//     } catch (e) {
//       log('Error export: $e');
//     }
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:hive/hive.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';
import 'package:nusantara_aset_app/core/models/data_aset_model.dart';
import 'package:nusantara_aset_app/core/models/barang_masuk_model.dart';
import 'package:nusantara_aset_app/core/models/barang_keluar_model.dart';
import 'package:nusantara_aset_app/core/models/pinjam_barang_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class ExportHelperBackup {
  /// Export all Hive boxes to Excel with embedded images using Syncfusion XlsIO
  static Future<void> exportWithXlsIO() async {
    final Workbook workbook = Workbook();
    final DateTime now = DateTime.now().toLocal();
    final String fileName = '${DateFormat('ddMMyyHHmmss').format(now)}_export.xlsx';

    Future<void> addSheetWithImage<T>({
      required String sheetName,
      required List<String> headers,
      required List<T> items,
      required List<List<String>> Function(List<T>) rowMapper,
      required String Function(T) imagePathGetter,
      required String imageHeaderName, // Menambahkan parameter untuk nama header gambar
    }) async {
      final Worksheet sheet = workbook.worksheets.addWithName(sheetName);

      // Header
      for (int c = 0; c < headers.length; c++) {
        final Range headerCell = sheet.getRangeByIndex(1, c + 1);
        headerCell.setText(headers[c]);
        headerCell.cellStyle.bold = true;

        // Menambahkan border pada header cell (atas, bawah, kiri, kanan)
        headerCell.cellStyle.borders.top.lineStyle = LineStyle.thin;
        headerCell.cellStyle.borders.top.color = '#000000';
        headerCell.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
        headerCell.cellStyle.borders.bottom.color = '#000000';
        headerCell.cellStyle.borders.left.lineStyle = LineStyle.thin;
        headerCell.cellStyle.borders.left.color = '#000000';
        headerCell.cellStyle.borders.right.lineStyle = LineStyle.thin;
        headerCell.cellStyle.borders.right.color = '#000000';
      }

      // Menambahkan header untuk kolom gambar dengan penyesuaian nama header
      final Range imgHeader = sheet.getRangeByIndex(1, headers.length + 1);
      imgHeader.setText(imageHeaderName); // Menggunakan parameter untuk nama header gambar
      imgHeader.cellStyle.bold = true;

      // Menambahkan border pada header gambar
      imgHeader.cellStyle.borders.top.lineStyle = LineStyle.thin;
      imgHeader.cellStyle.borders.top.color = '#000000';
      imgHeader.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
      imgHeader.cellStyle.borders.bottom.color = '#000000';
      imgHeader.cellStyle.borders.left.lineStyle = LineStyle.thin;
      imgHeader.cellStyle.borders.left.color = '#000000';
      imgHeader.cellStyle.borders.right.lineStyle = LineStyle.thin;
      imgHeader.cellStyle.borders.right.color = '#000000';

      final List<List<String>> rows = rowMapper(items);

      // Data Cell
      for (int r = 0; r < rows.length; r++) {
        final int excelRow = r + 2; // Mulai dari baris kedua untuk data
        for (int c = 0; c < rows[r].length; c++) {
          // sheet.getRangeByIndex(excelRow, c + 1).setText(rows[r][c]);
          final cell = sheet.getRangeByIndex(excelRow, c + 1);
          cell.setText(rows[r][c]);
          cell.cellStyle.hAlign = HAlignType.center;
          cell.cellStyle.vAlign = VAlignType.center;

          // Menambahkan border pada setiap data cell (atas, bawah, kiri, kanan)
          cell.cellStyle.borders.top.lineStyle = LineStyle.thin;
          cell.cellStyle.borders.top.color = '#000000';
          cell.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
          cell.cellStyle.borders.bottom.color = '#000000';
          cell.cellStyle.borders.left.lineStyle = LineStyle.thin;
          cell.cellStyle.borders.left.color = '#000000';
          cell.cellStyle.borders.right.lineStyle = LineStyle.thin;
          cell.cellStyle.borders.right.color = '#000000';
        }

        final String imgPath = imagePathGetter(items[r]);
        if (imgPath.isNotEmpty && File(imgPath).existsSync()) {
          final List<int> bytes = await File(imgPath).readAsBytes();
          final picture = sheet.pictures.addStream(
            excelRow, // Posisi baris untuk gambar
            headers.length + 1, // Posisi kolom untuk gambar
            bytes, // Data gambar dalam bentuk byte
          );

          // Setel ukuran gambar (tinggi dan lebar dalam piksel)
          picture.height = 75; // 60 piksel
          picture.width = 75; // 60 piksel

          // Sesuaikan tinggi baris agar sesuai dengan gambar (60 piksel)
          sheet.getRangeByIndex(excelRow, 1).rowHeight = 60; // tinggi cell di excel

          // Menambahkan border pada sel tempat gambar diletakkan
          final Range pictureCell = sheet.getRangeByIndex(excelRow, headers.length + 1);
          pictureCell.cellStyle.borders.top.lineStyle = LineStyle.thin;
          pictureCell.cellStyle.borders.top.color = '#000000';
          pictureCell.cellStyle.borders.bottom.lineStyle = LineStyle.thin;
          pictureCell.cellStyle.borders.bottom.color = '#000000';
          pictureCell.cellStyle.borders.left.lineStyle = LineStyle.thin;
          pictureCell.cellStyle.borders.left.color = '#000000';
          pictureCell.cellStyle.borders.right.lineStyle = LineStyle.thin;
          pictureCell.cellStyle.borders.right.color = '#000000';
        }
      }

      // Sesuaikan lebar kolom otomatis berdasarkan panjang teks di setiap kolom
      for (int c = 0; c < headers.length; c++) {
        int maxLength = headers[c].length;
        // Iterasi untuk mencari panjang maksimal teks di setiap kolom
        for (int r = 0; r < rows.length; r++) {
          final String cellText = rows[r][c];
          maxLength = max(maxLength, cellText.length);
        }

        // Menyesuaikan lebar kolom berdasarkan panjang teks maksimal
        sheet.getRangeByIndex(1, c + 1).columnWidth =
            maxLength + 2; // Tambahkan sedikit ruang agar rapi
      }

      // Jika hanya ada satu gambar, pastikan gambar memiliki ukuran dan kolom memiliki lebar yang sesuai
      if (items.isNotEmpty) {
        sheet.getRangeByIndex(2, headers.length + 1).rowHeight = 60;
        sheet.getRangeByIndex(1, headers.length + 1).columnWidth = 10; // Atur sesuai kebutuhan
      }
    }

    // Hive boxes
    final boxAset = Hive.box<DataAsetModel>(HiveHelper.dataAsetBox);
    final boxMasuk = Hive.box<BarangMasukModel>(HiveHelper.barangMasukBox);
    final boxKeluar = Hive.box<BarangKeluarModel>(HiveHelper.barangKeluarBox);
    final boxPinjam = Hive.box<PinjamBarangModel>(HiveHelper.pinjamBarangBox);

    await addSheetWithImage<DataAsetModel>(
      sheetName: 'DataAset',
      headers: ['ID', 'Nama', 'Lokasi', 'Created At'],
      items: boxAset.values.toList(),
      rowMapper:
          (list) =>
              list
                  .map((e) => [e.id, e.name, e.location, e.createdAt.toDateTimeFormatString()])
                  .toList(),
      imagePathGetter: (e) => e.image,
      imageHeaderName: 'Gambar', // Ubah nama header gambar sesuai keinginan
    );

    await addSheetWithImage<BarangMasukModel>(
      sheetName: 'BarangMasuk',
      headers: ['ID', 'Pengirim', 'Penerima', 'Keterangan', 'Created At'],
      items: boxMasuk.values.toList(),
      rowMapper:
          (list) =>
              list
                  .map(
                    (e) => [
                      e.id,
                      e.pengirim,
                      e.penerima,
                      e.keterangan,
                      e.createdAt.toDateTimeFormatString(),
                    ],
                  )
                  .toList(),
      imagePathGetter: (e) => e.image,
      imageHeaderName: 'Gambar', // Ubah nama header gambar sesuai keinginan
    );

    await addSheetWithImage<BarangKeluarModel>(
      sheetName: 'BarangKeluar',
      headers: ['ID', 'Pengirim', 'Tujuan', 'Keterangan', 'Created At'],
      items: boxKeluar.values.toList(),
      rowMapper:
          (list) =>
              list
                  .map(
                    (e) => [
                      e.id,
                      e.pengirim,
                      e.tujuan,
                      e.keterangan,
                      e.createdAt.toDateTimeFormatString(),
                    ],
                  )
                  .toList(),
      imagePathGetter: (e) => e.image,
      imageHeaderName: 'Gambar', // Ubah nama header gambar sesuai keinginan
    );

    await addSheetWithImage<PinjamBarangModel>(
      sheetName: 'PinjamBarang',
      headers: ['ID', 'Peminjam', 'PenanggungJawab', 'TglPinjam', 'TglKembali', 'Keterangan'],
      items: boxPinjam.values.toList(),
      rowMapper:
          (list) =>
              list
                  .map(
                    (e) => [
                      e.id,
                      e.peminjam,
                      e.penanggungJawab,
                      e.tanggalPeminjaman.toDateTimeFormatString(),
                      e.tanggalKembalikan?.toDateTimeFormatString() ?? '',
                      e.keterangan,
                    ],
                  )
                  .toList(),
      imagePathGetter: (e) => e.imageKembalikan ?? e.imagePeminjaman,
      imageHeaderName: 'Gambar', // Ubah nama header gambar sesuai keinginan
    );

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // Save file
    final Directory? dir = await getExternalStorageDirectory();
    final String path = dir?.path ?? (await getApplicationDocumentsDirectory()).path;
    final File output = File('$path/$fileName');
    await output.writeAsBytes(bytes, flush: true);

    print('Excel exported with images: ${output.path}');
  }
}


// import 'package:flutter/services.dart' show rootBundle;
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:developer';

// class Barang {
//   final String nama;
//   final String assetImagePath;

//   Barang({required this.nama, required this.assetImagePath});
// }

// Future<void> exportToExcelWithImages(List<Barang> barangList, String fileName) async {
//   final workbook = xlsio.Workbook();
//   final sheet = workbook.worksheets[0];

//   // Header
//   sheet.getRangeByName('A1').setText('Nama Barang');
//   sheet.getRangeByName('B1').setText('Gambar');

//   // Atur lebar kolom dan tinggi baris agar muat gambar kecil
//   sheet.getRangeByName('A1').columnWidth = 30;
//   sheet.getRangeByName('B1').columnWidth = 18;

//   for (int i = 0; i < barangList.length; i++) {
//     final barang = barangList[i];
//     final row = i + 2;

//     // Nama barang
//     sheet.getRangeByName('A$row').setText(barang.nama);
//     sheet.getRangeByName('A$row').cellStyle.wrapText = true;

//     // Load image dari assets
//     final ByteData imageData = await rootBundle.load(barang.assetImagePath);
//     final Uint8List imageBytes = imageData.buffer.asUint8List();

//     // Tambahkan gambar ke sel baris 'row' dan kolom B (index 2)
    // final picture = sheet.pictures.addStream(row, 2, imageBytes);
    // picture.height = 60; // px
    // picture.width = 60; // px

//     // Atur tinggi baris agar sesuai gambar
//     sheet.getRangeByIndex(row, 1).rowHeight = 50;
//   }

//   // Simpan file
//   final List<int> bytes = workbook.saveAsStream();
//   final dir = await getExternalStorageDirectory();
//   final output = File('${dir!.path}/$fileName');
//   await output.writeAsBytes(bytes, flush: true);
//   workbook.dispose();

//   log('Excel exported with images: ${output.path}');
// }
