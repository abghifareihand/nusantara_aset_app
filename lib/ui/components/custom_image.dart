// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String label;
  final File? imageFile;
  final Function()? onTap;

  const CustomImage({super.key, required this.label, required this.onTap, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12.0),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                imageFile == null
                    ? const Icon(Icons.image, size: 50, color: Colors.grey)
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(imageFile!, fit: BoxFit.cover),
                    ),
          ),
        ),
      ],
    );
  }
}
