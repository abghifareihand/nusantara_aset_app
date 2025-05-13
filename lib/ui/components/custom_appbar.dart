import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nusantara_aset_app/core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const CustomAppBar({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight), // ukuran standar AppBar
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.secondary, AppColors.primary],
            stops: [0.0, 1.0],
          ),
        ),
        child: AppBar(
          centerTitle: true,
          title: SizedBox(
            width: 120,
            height: 120,
            child: SvgPicture.asset('assets/icons/logo_white.svg', fit: BoxFit.contain),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading:
              showBackButton
                  ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  )
                  : null,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
