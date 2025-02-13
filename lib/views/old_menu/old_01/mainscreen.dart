import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    Routes.textrecognitiontranslationscreen,
    Routes.aboutscreen,
  ];

  List itemLanguage = ['English', 'Bahasa Indonesia', '日本語'];
  String? _language;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Ambil language dari SharedPreferences
    SharedPreferencesHelper.readLanguage().then((lang) {
      setState(() {
        _language = lang;
        print('initial _language = $_language');
        context.setLocale(Locale(setLocalLanguage(_language)));
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
    // Mengetahui ukuran layar
    Size size = MediaQuery.of(context).size;

    if (1 + 1 == 2) {
      print('object');
    }
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.lightBlueAccent,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      //backgroundColor: Colors.lightBlueAccent,
      body: Column(children: [
        Expanded(
          child: tampilkanListMenu(mainMenu)
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
                child: DropdownButton(
                  value: _language,
                  icon: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: SvgPicture.asset(
                      'assets/icons/carbon-design-system/32/triangle--down--solid.svg',
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      width: 10,
                      height: 10,
                      semanticsLabel: 'Triangle Down Solid',
                    ),
                  ),
                  underline: Container(color: Colors.transparent),
                  iconEnabledColor: Colors.white,
                  dropdownColor: Colors.indigo[900],
                  items: itemLanguage.map((bahasa) {
                    print('value item = $bahasa');
                    return DropdownMenuItem(
                      value: bahasa,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: listLanguage(bahasa),
                          ),
                          Text(
                            bahasa,
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
                    print('value onChanged = $value');
                    print('locale awal = ${LocaleKeys.dictionary.tr()}');

                    // Aksi
                    SharedPreferencesHelper.saveLanguage(value.toString()).then((val) {
                      setState(() {
                        print('onchange _language before = $_language');
                        _language = value.toString();
                        print('onchange _language after = $_language');
                        
                        // Ubah localekeys
                        context.setLocale(Locale(setLocalLanguage(_language)));
                        print('locale baru = ${LocaleKeys.dictionary.tr()}');
                      });
                    });
                  },
                  hint: initDropdownMenuItem(_language!),
                  isExpanded: true,
                ),
              ),
            ),
          ),
        ),
      ]),
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

  Image? listLanguage(String bahasa) {
    if (bahasa == 'Bahasa Indonesia') {
      return Image.asset(
        'assets/icons/icons8-indonesia-48.png',
        width: 25,
        height: 25,
      );
    } else if (bahasa == 'English') {
      return Image.asset(
        'assets/icons/icons8-usa-48.png',
        width: 25,
        height: 25,
      );
    } else if (bahasa == '日本語') {
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
          'Language',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ]);
    } else {
      return Row(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: listLanguage(lang),
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
    if(lang == 'Bahasa Indonesia') {
      return 'id';
    } else if(lang == 'English') {
      return 'en';
    } else if(lang == '日本語') {
      return 'ja';
    }
    return '';
  }
}
