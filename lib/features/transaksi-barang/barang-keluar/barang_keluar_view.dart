import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/barang-keluar/search_barang_keluar_view.dart';
import 'package:nusantara_aset_app/features/transaksi-barang/transaksi_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/ui/components/custom_date_time_picker.dart';
import 'package:nusantara_aset_app/ui/components/custom_image.dart';
import 'package:nusantara_aset_app/ui/components/custom_text_field.dart';
import 'package:nusantara_aset_app/ui/widgets/select_image_upload.dart';

class BarangKeluarView extends StatelessWidget {
  const BarangKeluarView({super.key});

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
            title: Text('Barang Keluar'),
            backgroundColor: AppColors.primary,
            elevation: 2,
            actions: [
              IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchBarangKeluarView()),
                  );
                  model.fetchBarangKeluar();
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
          controller: model.pengirimOutController,
          label: 'Pengirim',
          onChanged: (value) => model.updatePengirimOut(value),
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: model.tujuanOutController,
          label: 'Tujuan',
          onChanged: (value) => model.updateTujuanOut(value),
        ),
        const SizedBox(height: 16.0),
        CustomImage(
          label: 'Foto',
          imageFile: model.imageOutFile,
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
              builder: (context) {
                return SelectImageUpload(
                  onGallerySelected: () => model.pickImageOut(),
                  onCameraSelected: () => model.cameraImageOut(),
                );
              },
            );
          },
        ),
        const SizedBox(height: 16.0),
        CustomDateTimePicker(
          label: 'Tanggal dan Waktu',
          controller: model.datetimeOutController,
          onChanged: (value) => model.updateDateTimeOut(value),
        ),
        const SizedBox(height: 16.0),
        CustomTextField(
          controller: model.keteranganOutController,
          label: 'Keterangan',
          maxLines: 3,
          onChanged: (value) => model.updateKeteranganOut(value),
        ),

        const SizedBox(height: 24.0),
        CustomButton.filled(
          onPressed:
              model.isFormValidOut
                  ? () {
                    model.createBarangKeluar();
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
