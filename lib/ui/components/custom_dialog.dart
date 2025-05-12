import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/ui/components/custom_button.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';

class CustomDialogDelete extends StatelessWidget {
  final String title;
  final Function()? onPressedCancel;
  final Function()? onPressedDelete;
  const CustomDialogDelete({
    super.key,
    required this.title,
    required this.onPressedCancel,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hapus Data',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.black),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Apakah anda yakin untuk menghapus $title ini?',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.dark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: CustomButton.outlined(
                    onPressed: onPressedCancel,
                    label: 'Batal',
                    fontSize: 14,
                    height: 42,
                    borderRadius: 8,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: CustomButton.filled(
                    onPressed: onPressedDelete,
                    label: 'Hapus',
                    fontSize: 14,
                    height: 42,
                    borderRadius: 8,
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
