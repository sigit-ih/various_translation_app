import 'package:easy_localization/easy_localization.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_translator_app_test/translations/codegen_loader.g.dart';
import 'package:pdf_translator_app_test/utilities/routes.dart';
import 'package:pdf_translator_app_test/views/blocs/dictionary_bloc.dart';
import 'package:pdf_translator_app_test/views/blocs/language_bloc.dart';
import 'package:pdf_translator_app_test/views/blocs/internet_bloc.dart';
import 'package:pdf_translator_app_test/views/mainscreen.dart';
import 'package:pdf_translator_app_test/views/splashscreen.dart';
import 'package:pdf_translator_app_test/views/submenu/aboutscreen.dart';
import 'package:pdf_translator_app_test/views/submenu/dictionaryscreen.dart';
import 'package:pdf_translator_app_test/views/submenu/documenttranslationscreen.dart';
import 'package:pdf_translator_app_test/views/submenu/ocrtranslationscreen.dart';
// import 'package:pdf_translator_app_test/nlp_detector_views/language_translator_view.dart'; // MLKit
import 'package:pdf_translator_app_test/views/submenu/wordtranslationscreen.dart'; // Old
// import 'package:pdf_translator_app_test/vision_detector_views/text_detector_view.dart'; // MLKit
import 'package:pdf_translator_app_test/views/submenu/textrecognitiontranslationscreen.dart'; // Old

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('id'), Locale('ja')],
      path: 'assets/translations/',
      startLocale: Locale('en'),
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LanguageBloc>(
            create: (context) => LanguageBloc()..add(LoadLanguageEvent()),
          ),
          BlocProvider(create: (context) => DictionaryBloc()),
          BlocProvider(create: (context) => InternetBloc()),
        ],
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock orientasi layar menjadi Portrait Up
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Various Translator',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashScreen(),
      routes: {
        Routes.splashscreen: (context) => const SplashScreen(),
        Routes.mainscreen: (context) => MainScreen(),
        Routes.dictionaryscreen: (context) => const DictionaryScreen(),
        Routes.wordtranslationscreen: (context) => const WordTranslationScreen(),
        Routes.ocrtranslationscreen: (context) => const OCRTranslationScreen(),
        Routes.documenttranslationscreen: (context) => const DocumentTranslationScreen(),
        Routes.textrecognitiontranslationscreen: (context) => const TextRecognitionTranslationScreen(),
        Routes.aboutscreen: (context) => const AboutScreen(),
      },
    );
  }
}
