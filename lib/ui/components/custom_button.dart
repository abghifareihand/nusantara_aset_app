import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';

enum ButtonStyleType { filled, outlined }

class CustomButton extends StatelessWidget {
  const CustomButton.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.filled,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.icon,
    this.suffixIcon,
    this.fontSize = 16.0,
    this.isLoading = false,
  });

  const CustomButton.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.outlined,
    this.color = Colors.transparent,
    this.textColor = AppColors.primary,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.icon,
    this.suffixIcon,
    this.isLoading = false,
    this.fontSize = 16.0,
  });

  final Function()? onPressed;
  final String label;
  final ButtonStyleType style;
  final Color color;
  final Color textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool isLoading;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child:
          style == ButtonStyleType.filled
              ? ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icon ?? const SizedBox.shrink(),
                            if (icon != null && label.isNotEmpty) const SizedBox(width: 10.0),
                            Text(
                              label,
                              style: TextStyle(
                                color: textColor,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (suffixIcon != null && label.isNotEmpty) const SizedBox(width: 10.0),
                            suffixIcon ?? const SizedBox.shrink(),
                          ],
                        ),
              )
              : OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  overlayColor: AppColors.primary,
                  backgroundColor: color,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icon ?? const SizedBox.shrink(),
                            if (icon != null && label.isNotEmpty) const SizedBox(width: 10.0),
                            Text(
                              label,
                              style: TextStyle(
                                color: textColor,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (suffixIcon != null && label.isNotEmpty) const SizedBox(width: 10.0),
                            suffixIcon ?? const SizedBox.shrink(),
                          ],
                        ),
              ),
    );
  }
}
