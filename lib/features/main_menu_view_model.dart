import 'dart:developer';
import 'dart:io';

import 'package:nusantara_aset_app/core/base/base_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class MainMenuViewModel extends BaseViewModel {
  @override
  Future<void> initModel() async {
    setLoading(true);
    if (Platform.isAndroid) {
      // Jika perangkat Android 11 (API 30) atau lebih tinggi
      if (Platform.version.startsWith('10') || Platform.version.startsWith('11')) {
        await requestManageExternalStoragePermission();
      } else {
        await requestStoragePermissions();
      }
    }
    setLoading(false);
  }

  Future<void> requestStoragePermissions() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      log('Storage permission granted');
    } else if (status.isDenied) {
      log('Storage permission denied');
    } else if (status.isPermanentlyDenied) {
      log('Storage permission permanently denied');
      openAppSettings(); // Arahkan pengguna ke pengaturan aplikasi
    }
  }

  Future<void> requestManageExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      log('Manage External Storage permission granted');
    } else if (status.isDenied) {
      log('Manage External Storage permission denied');
    } else if (status.isPermanentlyDenied) {
      log('Manage External Storage permission permanently denied');
      openAppSettings();
    }
  }
}
