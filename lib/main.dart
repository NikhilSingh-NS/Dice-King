import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dice_app/utils/dependency_assembly.dart';
import 'package:firebase_core/firebase_core.dart';

import 'routes.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUpDependencyAssembly();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'IN'), Locale('hi', 'IN')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'IN'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice King',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: Routes().navigatorKey,
      routes: Routes().map,
    );
  }
}
