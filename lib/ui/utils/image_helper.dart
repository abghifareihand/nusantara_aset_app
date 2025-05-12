import 'dart:io';
import 'package:flutter/material.dart';

class ImageHelper {
  static Widget loadLocalImage(String? path, {double width = 60, double height = 60}) {
    if (path == null || path.isEmpty || !File(path).existsSync()) {
      return Image.asset(
        'assets/images/img_default.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(path),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/img_default.png',
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
      );
    }
  }
}
