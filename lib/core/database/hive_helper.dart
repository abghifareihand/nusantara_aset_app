import 'package:hive_flutter/hive_flutter.dart';
import 'package:nusantara_aset_app/core/models/data_aset_model.dart';

class HiveHelper {
  // key
  static const String dataAsetBox = 'dataAset';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(DataAsetModelAdapter());
    await Hive.openBox<DataAsetModel>(dataAsetBox);
  }
}
