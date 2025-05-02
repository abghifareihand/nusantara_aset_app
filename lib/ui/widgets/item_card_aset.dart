import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';

class ItemCardAset extends StatelessWidget {
  final String name;
  final String image;
  final String createdAt;
  final int index;
  final Function()? onTap;
  final Function()? onLongPress;
  const ItemCardAset({
    super.key,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.index,
    this.onTap,
    this.onLongPress,
  });

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
              child: Image.file(File(image), width: 48, height: 48, fit: BoxFit.cover),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.black)),
                  Text(
                    createdAt,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.dark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ClipOval(
              child: Container(
                width: 30,
                height: 30,
                color: AppColors.primary,
                alignment: Alignment.center,
                child: Text('${index + 1}', style: TextStyle(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
