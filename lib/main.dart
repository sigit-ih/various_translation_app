import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_translator_app_test/translations/codegen_loader.g.dart';
import 'package:pdf_translator_app_test/views/submenu/aboutscreen.dart';
import 'package:pdf_translator_app_test/views/submenu/dictionaryscreen.dart';
import 'package:pdf_translator_app_test/views/submenu/documenttranslationscreen.dart';
import 'package:pdf_translator_app_test/views/submenu/ocrtranslationscreen.dart';
import 'package:pdf_translator_app_test/views/submenu/realtimetexttranslationscreen.dart';
import 'package:pdf_translator_app_test/views/submenu/wordtranslationscreen.dart';

import 'utilities/routes.dart';
import 'views/mainscreen.dart';
import 'views/splashscreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //runApp(const MainApp());

  runApp(EasyLocalization(
    // run this command on terminal to generate localizations assets
    // to add new text, please use i18n manager (open source tools)
    // flutter pub run easy_localization:generate -S "assets/translations" -O "lib/translations"
    // flutter pub run easy_localization:generate -S "assets/translations" -O "lib/translations" -o "locale_keys.g.dart" -f keys

    child: MainApp(),
    supportedLocales: [Locale('en'), Locale('id'), Locale('ja')],
    path: 'assets/translations/',
    startLocale: Locale('en'), // default locale language (https://www.npmjs.com/package/i18n-iso-countries)
    fallbackLocale: Locale('en'), //
    assetLoader: CodegenLoader(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock orientasi layar menjadi Portrait Up
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghapus ribbon debug di kanan atas
      title: 'Various Translator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: SplashScreen(),
      routes: {
        Routes.splashscreen: (context) => SplashScreen(),
        Routes.mainscreen: (context) => MainScreen(),
        Routes.dictionaryscreen: (context) => DictionaryScreen(),
        Routes.wordtranslationscreen: (context) => WordTranslationScreen(),
        Routes.ocrtranslationscreen: (context) => OCRTranslationScreen(),
        Routes.documenttranslationscreen: (context) => DocumentTranslationScreen(),
        Routes.realtimetexttranslationscreen: (context) => RealTimeTextTranslationScreen(),
        Routes.aboutscreen: (context) => AboutScreen(), 
        
      },
    );
  }
}
