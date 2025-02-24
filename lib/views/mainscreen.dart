import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_translator_app_test/views/blocs/language_bloc.dart';
import 'package:pdf_translator_app_test/views/blocs/internet_bloc.dart';
import 'package:pdf_translator_app_test/translations/locale_keys.g.dart';
import 'package:pdf_translator_app_test/utilities/routes.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<String> menuIcon = [
    'assets/icons/carbon-design-system/32/translate.svg',
    'assets/icons/object-based/document_32.svg',
    'assets/icons/ibm-watson--natural-language-understanding.svg',
    'assets/icons/carbon-design-system/32/document--processor.svg',
    'assets/icons/carbon-design-system/32/text--creation.svg',
    'assets/icons/carbon-design-system/32/help.svg'
  ];

  final List<dynamic> menuLink = [
    Routes.wordtranslationscreen,
    Routes.dictionaryscreen,
    Routes.ocrtranslationscreen,
    Routes.documenttranslationscreen,
    Routes.textrecognitiontranslationscreen,
    Routes.aboutscreen,
  ];

  final List<String> languageItem = ['English', 'Indonesia', '日本語'];

  @override
  Widget build(BuildContext context) {
    context.read<LanguageBloc>().add(LoadLanguageEvent());

    Size size = MediaQuery.of(context).size;

    return BlocBuilder<InternetBloc, InternetState>(
      builder: (context, state) {
        // Cek jika status koneksi masih dalam tahap inisialisasi
      if (state is InternetInitial) {
        // Tampilkan loading indicator saat status koneksi belum diketahui
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),  // Menampilkan loading indicator atau UI lainnya
          ),
        );
      }

      // Jika koneksi terputus, tampilkan pesan error
      if (state is InternetDisconnected) {
        return Scaffold(
          body: Center(
            child: Text(
              'Tidak ada koneksi internet, \nsilakan aktifkan koneksi internet',
              style: TextStyle(color: Colors.indigo.shade800, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      // Jika koneksi terhubung, tampilkan UI utama
      return Scaffold(
          appBar: AppBar(
            titleTextStyle: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, state) {
                    List<String> mainMenu = [
                      LocaleKeys.translation.tr(),
                      LocaleKeys.dictionary.tr(),
                      LocaleKeys.ocr_translation.tr(),
                      LocaleKeys.document_translation.tr(),
                      LocaleKeys.text_recognition_translation.tr(),
                      LocaleKeys.about.tr()
                    ];
                    return displayMenuList(mainMenu, context);
                  },
                ),
              ),
              BlocListener<LanguageBloc, LanguageState>(
                listener: (context, state) {
                  context.setLocale(Locale(setLocalLanguage(state.language)));
                },
                child: Card(
                  color: Colors.indigo[900],
                  margin: const EdgeInsets.fromLTRB(15, 5, 15, 50),
                  child: SizedBox(
                    width: size.width,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: BlocBuilder<LanguageBloc, LanguageState>(
                        builder: (context, state) {
                          return DropdownButton(
                            isExpanded: true,
                            value: state.language,
                            icon: SvgPicture.asset(
                              'assets/icons/carbon-design-system/32/triangle--down--solid.svg',
                              colorFilter: const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn),
                              width: 10,
                              height: 10,
                            ),
                            underline: Container(color: Colors.transparent),
                            iconEnabledColor: Colors.white,
                            dropdownColor: Colors.indigo[900],
                            items: languageItem.map((bahasa) {
                              return DropdownMenuItem(
                                value: bahasa,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        child: listLanguage(bahasa)),
                                    Text(
                                      bahasa,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                context.read<LanguageBloc>().add(ChangeLanguageEvent(value));
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget displayMenuList(List<String> mainMenuList, BuildContext context) {
    return ListView.builder(
        itemCount: mainMenuList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, menuLink[index]);
            },
            child: Card(
              color: Colors.indigo[900],
              margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: SvgPicture.asset(
                        menuIcon[index],
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                        width: 25,
                        height: 25,
                      ),
                    ),
                    Text(
                      mainMenuList[index],
                      style: const TextStyle(
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

  Widget listLanguage(String lang) {
    Map<String, String> flagIcons = {
      'Indonesia': 'assets/icons/icons8-indonesia-48.png',
      'English': 'assets/icons/icons8-usa-48.png',
      '日本語': 'assets/icons/icons8-japan-48.png',
    };

    return flagIcons.containsKey(lang)
        ? Image.asset(
            flagIcons[lang]!,
            width: 40,
            height: 40,
          )
        : SizedBox();
  }

  String setLocalLanguage(String? lang) {
    if (lang == 'Indonesia') {
      return 'id';
    } else if (lang == 'English') {
      return 'en';
    } else if (lang == '日本語') {
      return 'ja';
    }
    return 'en';
  }
}