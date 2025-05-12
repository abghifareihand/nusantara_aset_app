import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/base/base_view.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/features/pinjam-barang/pinjam_barang_view_model.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/ui/components/custom_date_time_picker.dart';
import 'package:nusantara_aset_app/ui/components/custom_image.dart';
import 'package:nusantara_aset_app/ui/widgets/item_card_pinjam.dart';
import 'package:nusantara_aset_app/ui/widgets/select_image_upload.dart';

class EditPinjamView extends StatelessWidget {
  const EditPinjamView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<PinjamBarangViewModel>(
      model: PinjamBarangViewModel(),
      onModelReady: (model) => model.initModel(),
      onModelDispose: (model) => model.disposeModel(),
      builder: (context, model, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Kembalikan Barang'),
            backgroundColor: AppColors.primary,
            elevation: 2,
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PinjamBarangViewModel model) {
    final filteredList =
        model.pinjamBarangList.where((item) => item.tanggalKembalikan == null).toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Text('Tidak barang yang perlu dikembalikan', style: TextStyle(fontSize: 16)),
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        model.fetchPinjamBarang();
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: filteredList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12.0),
        itemBuilder: (BuildContext context, int index) {
          final data = filteredList[index];
          return ItemCardPinjam(
            data: data,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        padding: EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  width: 42,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppColors.grey,
                                  ),
                                ),
                              ),
                              CustomImage(
                                label: 'Foto Kembalikan',
                                imageFile: model.imageKembalikanFile,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12.0),
                                      ),
                                    ),
                                    builder: (context) {
                                      return SelectImageUpload(
                                        onGallerySelected: () async {
                                          await model.pickImageKembalikan();
                                          setState(() {});
                                        },
                                        onCameraSelected: () async {
                                          await model.cameraImageKembalikan();
                                          setState(() {});
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 16.0),
                              CustomDateTimePicker(
                                label: 'Tanggal dan Waktu Kembalikan',
                                controller: model.datetimeKembalikanController,
                                onChanged: (value) => model.updateDateTimePeminjaman(value),
                              ),
                              const SizedBox(height: 24.0),
                              CustomButton.filled(
                                onPressed: () {
                                  model.updatePinjamBarang(data.id);
                                  Navigator.pop(context);
                                },
                                label: 'Simpan',
                              ),
                              const SizedBox(height: 24.0),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
