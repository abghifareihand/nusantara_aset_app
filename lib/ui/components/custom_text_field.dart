import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization capitalization;
  final bool showLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool isOutlineBorder;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.capitalization = TextCapitalization.none,
    this.showLabel = true,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.isOutlineBorder = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12.0),
        ],
        TextFormField(
          cursorColor: AppColors.primary,
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: capitalization,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Masukkan $label',
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border:
                isOutlineBorder
                    ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    )
                    : null,
            enabledBorder:
                isOutlineBorder
                    ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    )
                    : null,
            focusedBorder:
                isOutlineBorder
                    ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
                    )
                    : null,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
