import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/core/models/data_aset_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';
import 'package:nusantara_aset_app/ui/utils/image_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemCardAset extends StatelessWidget {
  final DataAsetModel data;
  final Function()? onTap;
  final Function()? onDelete;
  final Function()? onEdit;
  final int index; // Menambahkan index
  const ItemCardAset({
    super.key,
    required this.data,
    this.onTap,
    this.onDelete,
    this.onEdit,
    required this.index, // Pastikan index diterima di konstruktor
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.secondary, AppColors.primary],
                  stops: [0.0, 1.0],
                ),
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(), // Menampilkan angka berdasarkan index
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageHelper.loadLocalImage(data.image),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.name,
                    style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.black),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    data.createdAt.toDateTimeFormatString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.dark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: onDelete,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset('assets/icons/ic_trash.svg'),
                  ),
                ),
                const SizedBox(width: 4.0),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: onEdit,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset('assets/icons/ic_pen.svg'),
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
