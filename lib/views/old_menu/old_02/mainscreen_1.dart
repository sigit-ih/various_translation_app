import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_translator_app_test/views/blocs/language_bloc.dart';
import 'package:pdf_translator_app_test/translations/locale_keys.g.dart';
import 'package:pdf_translator_app_test/utilities/routes.dart';
import 'package:pdf_translator_app_test/utilities/sharedpreferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> iconMenu = [
    'assets/icons/carbon-design-system/32/translate.svg',
    'assets/icons/object-based/document_32.svg',
    'assets/icons/ibm-watson--natural-language-understanding.svg',
    'assets/icons/carbon-design-system/32/document--processor.svg',
    'assets/icons/carbon-design-system/32/text--creation.svg',
    'assets/icons/carbon-design-system/32/help.svg'
  ];

  List<String> mainMenu = [];

  List<dynamic> linkMenu = [
    Routes.wordtranslationscreen,
    Routes.dictionaryscreen,
    Routes.ocrtranslationscreen,
    Routes.documenttranslationscreen,
    Routes.realtimetexttranslationscreen,
    Routes.aboutscreen,
  ];

  List itemLanguage = ['English', 'Indonesia', '日本語'];
  String _language = 'English';

  @override
  void initState() {
    super.initState();

    // Ambil language dari SharedPreferences
    SharedPreferencesHelper.readLanguage().then((lang) {
      setState(() {
        print("Init _language before : $_language");
        _language = lang;
        print("Init _language after : $_language");
        print("Init Locale before : ${context.locale.toString()}");
        context.setLocale(Locale(setLocalLanguage(_language)));
        print("Init Locale after : ${context.locale.toString()}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mainMenu = [
      LocaleKeys.translation.tr(),
      LocaleKeys.dictionary.tr(),
      LocaleKeys.ocr_translation.tr(),
      LocaleKeys.document_translation.tr(),
      LocaleKeys.text_recognition_translation.tr(),
      LocaleKeys.about.tr()
    ];

    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => LanguageBloc(),
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
            child: tampilkanListMenu(mainMenu),
          ),
          Card(
            color: Colors.indigo[900],
            margin: EdgeInsets.fromLTRB(15, 5, 15, 50),
            child: SizedBox(
              width: size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, state) {
                      return DropdownButton(
                        value: _language,
                        icon: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: SvgPicture.asset(
                            'assets/icons/carbon-design-system/32/triangle--down--solid.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                            width: 10,
                            height: 10,
                            semanticsLabel: 'Triangle Down Solid',
                          ),
                        ),
                        underline: Container(color: Colors.transparent),
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.indigo[900],
                        items: itemLanguage.map((bahasa) {
                          return DropdownMenuItem(
                            value: bahasa,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: listLanguage(bahasa) ??
                                      Image.asset(
                                        'assets/icons/icons8-global-50.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                ),
                                Text(
                                  bahasa ?? '-',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          SharedPreferencesHelper.saveLanguage(value.toString())
                              .then((val) {
                            setState(() {
                              print("onChange _language before : $_language");
                              _language = value.toString();
                              print("onChange _language after : $_language");
                              print(
                                  "onChange Locale before : ${context.locale.toString()}");
                              context.setLocale(
                                  Locale(setLocalLanguage(_language)));
                              print(
                                  "onChange Locale after : ${context.locale.toString()}");
                            });
                            context
                                .read<LanguageBloc>()
                                .add(ChangeLanguageEvent(value.toString()));
                          });
                        },
                        hint: initDropdownMenuItem(_language!),
                        isExpanded: true,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  tampilkanListMenu(List<String> listMainMenu) {
    return ListView.builder(
        itemCount: listMainMenu.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              // Pindah screen
              Navigator.pushNamed(context, linkMenu[index]);
            },
            child: Card(
              color: Colors.indigo[900],
              margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: SvgPicture.asset(
                        iconMenu[index],
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                        width: 25,
                        height: 25,
                        semanticsLabel: listMainMenu[index],
                      ),
                    ),
                    Text(
                      listMainMenu[index],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Image? listLanguage(String lang) {
    if (lang == 'Indonesia') {
      return Image.asset(
        'assets/icons/icons8-indonesia-48.png',
        width: 25,
        height: 25,
      );
    } else if (lang == 'English') {
      return Image.asset(
        'assets/icons/icons8-usa-48.png',
        width: 25,
        height: 25,
      );
    } else if (lang == '日本語') {
      return Image.asset(
        'assets/icons/icons8-japan-48.png',
        width: 25,
        height: 25,
      );
    }
    return null;
  }

  Widget initDropdownMenuItem(String lang) {
    if (lang == '') {
      return Row(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Image.asset('assets/icons/icons8-global-50.png',
              width: 25, height: 25),
        ),
        Text(
          '-',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ]);
    } else {
      return Row(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: listLanguage(lang) ??
              Image.asset(
                'assets/icons/icons8-global-50.png',
                width: 25,
                height: 25,
              ),
        ),
        Text(
          lang,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ]);
    }
  }

  String setLocalLanguage(String? lang) {
    if (lang == 'Indonesia') {
      return 'id';
    } else if (lang == 'English') {
      return 'en';
    } else if (lang == '日本語') {
      return 'ja';
    }
    return '';
  }
}
