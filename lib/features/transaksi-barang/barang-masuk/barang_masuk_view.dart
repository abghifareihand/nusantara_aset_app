import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/barang-masuk/search_barang_masuk_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/transaksi_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/ui/components/custom_date_time_picker.dart';
import 'package:nusantara_aset_app/ui/components/custom_image.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/ui/widgets/select_image_upload.dart';

class BarangMasukView extends StatelessWidget {
  const BarangMasukView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<TransaksiBarangViewModel>(
      model: TransaksiBarangViewModel(),
      onModelReady: (TransaksiBarangViewModel model) => model.initModel(),
      onModelDispose: (TransaksiBarangViewModel model) => model.disposeModel(),
      builder: (BuildContext context, TransaksiBarangViewModel model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Barang Masuk'),
            backgroundColor: AppColors.primary,
            elevation: 2,
            actions: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchBarangMasukView()),
                  );
                  model.fetchBarangMasuk();
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TransaksiBarangViewModel model) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: <Widget>[
        CustomTextField(
          controller: model.pengirimInController,
          label: 'Pengirim',
          onChanged: (value) => model.updatePengirimIn(value),
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: model.penerimaInController,
          label: 'Penerima',
          onChanged: (value) => model.updatePenerimaIn(value),
        ),
        const SizedBox(height: 16.0),
        CustomImage(
          label: 'Foto',
          imageFile: model.imageInFile,
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
              builder: (context) {
                return SelectImageUpload(
                  onGallerySelected: () => model.pickImageIn(),
                  onCameraSelected: () => model.cameraImageIn(),
                );
              },
            );
          },
        ),
        const SizedBox(height: 16.0),
        CustomDateTimePicker(
          label: 'Tanggal dan Waktu',
          controller: model.datetimeInController,
          onChanged: (value) => model.updateDateTimeIn(value),
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: model.keteranganInController,
          label: 'Keterangan',
          maxLines: 3,
          onChanged: (value) => model.updateKeteranganIn(value),
        ),

        const SizedBox(height: 24.0),
        CustomButton.filled(
          onPressed:
              model.isFormValidIn
                  ? () {
                    model.createBarangMasuk();
                    Navigator.pop(context);
                  }
                  : null,
          label: 'Simpan',
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}
