import 'package:flutter/material.dart';

class SelectImageUpload extends StatelessWidget {
  final VoidCallback onGallerySelected;
  final VoidCallback onCameraSelected;

  const SelectImageUpload({
    super.key,
    required this.onGallerySelected,
    required this.onCameraSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Pilih dari galeri'),
            onTap: () {
              Navigator.pop(context);
              onGallerySelected();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Ambil dengan kamera'),
            onTap: () {
              Navigator.pop(context);
              onCameraSelected();
            },
          ),
        ],
      ),
    );
  }
}
