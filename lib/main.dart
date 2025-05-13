import 'package:flutter/material.dart';
import 'package:nusantara_aset_app/core/database/hive_helper.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nusantara_aset_app/features/splash_view.dart';

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('id')],
      theme: ThemeData(useMaterial3: false),
      home: SplashView(),
    );
  }
}
