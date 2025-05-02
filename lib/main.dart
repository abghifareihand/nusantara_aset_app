import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';
import 'package:nusantara_aset_app/features/main_menu_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nusantara Aset',
      theme: ThemeData(useMaterial3: false),
      home: MainMenuView(),
    );
  }
}
