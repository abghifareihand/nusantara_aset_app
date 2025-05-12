import 'package:hive_flutter/hive_flutter.dart';
import 'package:nusantara_aset_app/core/models/barang_keluar_model.dart';
import 'package:nusantara_aset_app/core/models/barang_masuk_model.dart';
import 'package:nusantara_aset_app/core/models/category_model.dart';
import 'package:nusantara_aset_app/core/models/data_aset_model.dart';
import 'package:nusantara_aset_app/core/models/pinjam_barang_model.dart';
import 'package:nusantara_aset_app/core/models/tools_model.dart';

class HiveHelper {
  // key
  static const String dataAsetBox = 'dataAset';
  static const String barangMasukBox = 'barangMasuk';
  static const String barangKeluarBox = 'barangKeluar';
  static const String pinjamBarangBox = 'pinjamBarang';
  static const String toolsBox = 'tools';
  static const String listToolsBox = 'listTools';

  // tested
  static const String categoryBox = 'category';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(DataAsetModelAdapter());
    await Hive.openBox<DataAsetModel>(dataAsetBox);

    Hive.registerAdapter(BarangMasukModelAdapter());
    await Hive.openBox<BarangMasukModel>(barangMasukBox);

    Hive.registerAdapter(BarangKeluarModelAdapter());
    await Hive.openBox<BarangKeluarModel>(barangKeluarBox);

    Hive.registerAdapter(PinjamBarangModelAdapter());
    await Hive.openBox<PinjamBarangModel>(pinjamBarangBox);

    Hive.registerAdapter(ToolsModelAdapter());
    await Hive.openBox<ToolsModel>(toolsBox);

    Hive.registerAdapter(ListToolsModelAdapter());
    await Hive.openBox<ListToolsModel>(listToolsBox);

    // tested
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(ListCategoryModelAdapter());
    await Hive.openBox<CategoryModel>(categoryBox);
  }
}
