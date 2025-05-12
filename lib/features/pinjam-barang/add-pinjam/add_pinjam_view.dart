import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/pinjam-barang/pinjam_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/ui/components/custom_date_time_picker.dart';
import 'package:nusantara_aset_app/ui/components/custom_image.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/ui/widgets/select_image_upload.dart';

class AddPinjamView extends StatelessWidget {
  const AddPinjamView({super.key});

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
            title: Text('Pinjam Barang'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PinjamBarangViewModel model) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        CustomTextField(
          controller: model.peminjamController,
          label: 'Peminjam',
          onChanged: (value) => model.updatePeminjam(value),
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: model.penanggungController,
          label: 'Penanggung Jawab',
          onChanged: (value) => model.updatePenanggung(value),
        ),
        const SizedBox(height: 16.0),
        CustomImage(
          label: 'Foto Peminjaman',
          imageFile: model.imagePeminjamanFile,
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
              builder: (context) {
                return SelectImageUpload(
                  onGallerySelected: () => model.pickImagePeminjaman(),
                  onCameraSelected: () => model.cameraImagePeminjaman(),
                );
              },
            );
          },
        ),
        const SizedBox(height: 16.0),
        CustomDateTimePicker(
          label: 'Tanggal dan Waktu Peminjaman',
          controller: model.datetimePeminjamanController,
          onChanged: (value) => model.updateDateTimePeminjaman(value),
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: model.keteranganController,
          label: 'Keterangan',
          maxLines: 3,
          onChanged: (value) => model.updateKeterangan(value),
        ),

        const SizedBox(height: 24.0),
        CustomButton.filled(
          onPressed: () {
            model.createPinjamBarang();
            Navigator.pop(context);
          },
          label: 'Simpan',
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}
