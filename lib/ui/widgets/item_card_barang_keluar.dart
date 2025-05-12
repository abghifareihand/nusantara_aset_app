import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/core/models/barang_keluar_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';
import 'package:nusantara_aset_app/ui/utils/image_helper.dart';

class ItemCardBarangKeluar extends StatelessWidget {
  final BarangKeluarModel data;
  final Function()? onTap;
  final Function()? onLongPress;
  const ItemCardBarangKeluar({super.key, required this.data, this.onTap, this.onLongPress});

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
              child: ImageHelper.loadLocalImage(data.image, width: 48, height: 48),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengirim',
                    style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.black),
                  ),
                  Text(
                    data.pengirim,
                    style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.dark),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Barang Keluar',
                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                ),
                Text(
                  data.createdAt.toDateTimeFormatString(),
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
