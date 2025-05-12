import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';
import 'package:nusantara_aset_app/core/models/tools_model.dart';
import 'package:nusantara_aset_app/ui/utils/extensions.dart';
import 'package:nusantara_aset_app/ui/utils/image_helper.dart';

class ItemCardTools extends StatelessWidget {
  final ToolsModel data;
  final bool isExpanded;
  final Function()? onTap;
  final Function()? onDelete;
  final Function()? onLongPress;

  const ItemCardTools({
    super.key,
    required this.data,
    required this.isExpanded,
    this.onTap,
    this.onDelete,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
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
                  child: ImageHelper.loadLocalImage(
                    data.listTools.first.image,
                    width: 48,
                    height: 48,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Tools (${data.listTools.length})',
                        style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.black),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < data.listTools.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: ImageHelper.loadLocalImage(
                            data.listTools[i].image,
                            width: 32,
                            height: 32,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.listTools[i].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                data.listTools[i].condition,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.dark,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: onDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.asset('assets/icons/ic_trash.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i != data.listTools.length - 1)
                    Divider(height: 16, color: Colors.grey.withValues(alpha: 0.5)),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
