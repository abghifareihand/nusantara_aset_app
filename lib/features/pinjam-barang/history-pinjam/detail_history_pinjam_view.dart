import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/core/models/pinjam_barang_model.dart';
import 'package:nusantara_aset_app/features/pinjam-barang/pinjam_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';

class DetailHistoryPinjamView extends StatelessWidget {
  final PinjamBarangModel pinjamBarang;
  const DetailHistoryPinjamView({super.key, required this.pinjamBarang});

  @override
  Widget build(BuildContext context) {
    return BaseView<PinjamBarangViewModel>(
      model: PinjamBarangViewModel(),
      onModelReady: (PinjamBarangViewModel model) => model.initModel(),
      onModelDispose: (PinjamBarangViewModel model) => model.disposeModel(),
      builder: (BuildContext context, PinjamBarangViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Detail History'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, pinjamBarang),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PinjamBarangModel pinjamBarang) {
    final tanggalPeminjaman = pinjamBarang.tanggalPeminjaman;
    final tanggalKembalikan = pinjamBarang.tanggalKembalikan;
    String durasiPeminjaman = '';
    if (tanggalKembalikan != null) {
      final duration = tanggalKembalikan.difference(tanggalPeminjaman);
      final days = duration.inDays;
      final hours = duration.inHours % 24;
      final minutes = duration.inMinutes % 60;
      if (days > 0 || hours > 0) {
        durasiPeminjaman = '$days hari $hours jam';
      } else {
        durasiPeminjaman = '$hours jam $minutes menit';
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Peminjaman Barang',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tanggal & Waktu',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              pinjamBarang.tanggalPeminjaman.toDateTimeFormatString(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(pinjamBarang.imagePeminjaman),
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 32.0),
        Text(
          'Pengembalian Barang',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tanggal & Waktu',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              pinjamBarang.tanggalKembalikan!.toDateTimeFormatString(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(pinjamBarang.imageKembalikan ?? ''),
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Durasi Peminjaman',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              durasiPeminjaman.isNotEmpty ? durasiPeminjaman : 'Durasi tidak tersedia',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
