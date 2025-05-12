import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/core/models/pinjam_barang_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';
import 'package:nusantara_aset_app/ui/utils/image_helper.dart';

class ItemCardPinjam extends StatelessWidget {
  final PinjamBarangModel data;
  final Function()? onTap;
  final Function()? onLongPress;
  const ItemCardPinjam({super.key, required this.data, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageHelper.loadLocalImage(data.imagePeminjaman, width: 48, height: 48),
            ),

            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Peminjam',
                    style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.black),
                  ),
                  Text(
                    data.peminjam,
                    style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.dark),
                  ),
                ],
              ),
            ),

            data.tanggalKembalikan == null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Belum Dikembalikan',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Sudah Dikembalikan',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      data.tanggalKembalikan!.toDateTimeFormatString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.dark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
