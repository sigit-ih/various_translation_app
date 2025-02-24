import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_translator_app_test/translations/locale_keys.g.dart';
import 'package:pdf_translator_app_test/utilities/sharedpreferences.dart';
import 'package:pdf_translator_app_test/utilities/texttospeech.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class WordTranslationScreen extends StatefulWidget {
  const WordTranslationScreen({super.key});

  @override
  State<WordTranslationScreen> createState() => _WordTranslationScreenState();
}

class _WordTranslationScreenState extends State<WordTranslationScreen> {
  // Dropdown Item
  List<String> languageList = [
    LocaleKeys.english.tr(),
    LocaleKeys.indonesian.tr(),
    LocaleKeys.japanese.tr()
  ];

  // Dropdown Language
  String sourceLanguageItem = LocaleKeys.english.tr();
  String targetLanguageItem = LocaleKeys.indonesian.tr();

  // Text to Speech
  final TextToSpeechService ttsService = TextToSpeechService();

  // Speech to text
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool isRecordingSpeech = false;
  String _lastWords = '';
  Color micButtonColor = Colors.indigo.shade800;
  Color micIconColor = Colors.white;

  // Translation Result
  TextEditingController _keywordTranslation = new TextEditingController();
  TranslateLanguage _sourceLanguage = TranslateLanguage.english;
  TranslateLanguage _targetLanguage = TranslateLanguage.indonesian;
  final modelManager = OnDeviceTranslatorModelManager();
  bool isResultVisible = false;
  String translationResult = '';

  // Timer translation
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    listenForPermissions();

    SharedPreferencesHelper.readLanguage().then((value) {
      setState(() {
        sourceLanguageItem = value;
        targetLanguageItem = (sourceLanguageItem != LocaleKeys.english.tr())
            ? LocaleKeys.english.tr()
            : LocaleKeys.indonesian.tr();

        // Update TranslateLanguage setelah mendapatkan data dari SharedPreferences
        _sourceLanguage = getTranslateLanguage(sourceLanguageItem);
        _targetLanguage = getTranslateLanguage(targetLanguageItem);

        context.setLocale(Locale(setLocalLanguage(sourceLanguageItem)));
      });
    });

    print(languageList);
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Batalkan debounce saat widget dihapus
    _keywordTranslation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String language1 = sourceLanguageItem;
    String language2 = targetLanguageItem;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(LocaleKeys.translation.tr()),
        backgroundColor: Colors.indigo[800],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: Color.fromARGB(255, 248, 248, 248),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      color: Color.fromARGB(255, 248, 248, 248),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Bubble(
                                padding: BubbleEdges.all(size.width * 0.03),
                                margin: BubbleEdges.only(top: 15, right: 5),
                                alignment: Alignment.topRight,
                                nip: BubbleNip.rightTop,
                                color: Color.fromRGBO(225, 255, 199, 1.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '~ $language1',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextField(
                                      maxLines: 6,
                                      style: TextStyle(
                                          fontSize: size.width * 0.035),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      maxLength: 300,
                                      controller: _keywordTranslation,
                                      onChanged: (value) {
                                        // Saat pengguna mengetik, tampilkan pesan menunggu translasi
                                        setState(() {
                                          translationResult = LocaleKeys
                                              .translation_process
                                              .tr();
                                          isResultVisible =
                                              true; // Pastikan teks terlihat
                                        });

                                        // Batalkan timer sebelumnya jika ada
                                        if (_debounce?.isActive ?? false)
                                          _debounce!.cancel();

                                        // Set timer baru untuk menunda translasi jika value tidak kosong
                                        if (value != '' ||
                                            value.replaceAll(' ', '') != '') {
                                          _debounce =
                                              Timer(Duration(seconds: 2), () {
                                            debugPrint(
                                                "Memulai proses translasi...");
                                            translationProcess(_sourceLanguage,
                                                _targetLanguage, value);
                                          });
                                        } else {
                                          // Jika value kosong, kembalikan keadaan seperti semula
                                          setState(() {
                                            translationResult = '';
                                            isResultVisible = false;
                                          });
                                        }
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            copyToClipboard(_keywordTranslation
                                                .text); // Salin teks dari TextField (_keywordTranslation)
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icons/carbon-design-system/32/copy.svg',
                                            colorFilter: ColorFilter.mode(
                                                Colors.red, BlendMode.srcIn),
                                            width: size.width * 0.06,
                                            height: size.width * 0.06,
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.03),
                                        InkWell(
                                          onTap: () async {
                                            if (ttsService.isSpeaking()) {
                                              await ttsService.stop();
                                              // setState(() {});
                                            } else {
                                              await ttsService.speak(
                                                  _keywordTranslation.text,
                                                  language1);
                                              // setState(() {});
                                            }
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icons/carbon-design-system/32/volume--up--filled.svg',
                                            colorFilter: ColorFilter.mode(
                                                Colors.red, BlendMode.srcIn),
                                            width: size.width * 0.06,
                                            height: size.width * 0.06,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            listLanguage(language1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      color: Color.fromARGB(255, 248, 248, 248),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            listLanguage(language2),
                            SizedBox(width: 10),
                            Expanded(
                              child: Bubble(
                                padding: BubbleEdges.all(size.width * 0.03),
                                margin: BubbleEdges.only(top: 15, left: 5),
                                alignment: Alignment.topLeft,
                                nip: BubbleNip.leftTop,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(),
                                          Text(
                                            '~ $language2',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: size.width * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                    if (isResultVisible)
                                      Column(
                                        children: [
                                          Container(
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            margin:
                                                EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            child: Text(
                                              translationResult,
                                              style: TextStyle(
                                                  fontSize: size.width * 0.035),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  copyToClipboard(
                                                      translationResult); // Salin teks dari TextField (_lastWords)
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/icons/carbon-design-system/32/copy.svg',
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.blue,
                                                      BlendMode.srcIn),
                                                  width: size.width * 0.06,
                                                  height: size.width * 0.06,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.03),
                                              InkWell(
                                                onTap: () async {
                                                  if (ttsService.isSpeaking()) {
                                                    await ttsService.stop();
                                                    // setState(() {});
                                                  } else {
                                                    await ttsService.speak(
                                                        translationResult,
                                                        language2);
                                                    // setState(() {});
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/icons/carbon-design-system/32/volume--up--filled.svg',
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.blue,
                                                      BlendMode.srcIn),
                                                  width: size.width * 0.06,
                                                  height: size.width * 0.06,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 7.5),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  iconSize: 0.0,
                                  elevation: 2,
                                  isExpanded: true,
                                  value: language1,
                                  hint: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(
                                      right: 5.0,
                                    ),
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Text(
                                      language1,
                                      style: TextStyle(
                                        color: Colors.indigo.shade800,
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  underline:
                                      Container(color: Colors.transparent),
                                  dropdownColor: Colors.white,
                                  items: listTranslateLanguage('1', size),
                                  onChanged: (value) {
                                    print('value onChanged source = $value');
                                    if (value != sourceLanguageItem &&
                                        value != targetLanguageItem) {
                                      changeLanguage(value.toString(),
                                          true); // Untuk Source Language
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: micButtonColor,
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                            ),
                            onPressed: _toggleSpeech,
                            child: SvgPicture.asset(
                              'assets/icons/carbon-design-system/32/microphone--filled.svg',
                              colorFilter: ColorFilter.mode(
                                  micIconColor, BlendMode.srcIn),
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 7.5),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton(
                                  iconSize: 0.0,
                                  elevation: 2,
                                  isExpanded: true,
                                  value: language2,
                                  hint: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(
                                      left: 5.0,
                                    ),
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      language2,
                                      style: TextStyle(
                                        color: Colors.indigo.shade800,
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  underline:
                                      Container(color: Colors.transparent),
                                  dropdownColor: Colors.white,
                                  items: listTranslateLanguage('2', size),
                                  onChanged: (value) {
                                    print('value onChanged target = $value');
                                    if (value != sourceLanguageItem &&
                                        value != targetLanguageItem) {
                                      // setState(() {
                                      //   // targetLanguageItem = value.toString();
                                      //   translationResult =
                                      //       ''; // Reset translation result saat dropdown berubah
                                      //   isResultVisible =
                                      //       false; // Sembunyikan hasil translasi sementara
                                      // });
                                      changeLanguage(value.toString(),
                                          false); // Untuk Target Language

                                      // Set timer baru untuk menunda translasi jika value tidak kosong
                                      if (translationResult != '' ||
                                          translationResult.replaceAll(' ', '') != '') {
                                        translationResult = LocaleKeys
                                              .translation_process
                                              .tr();
                                          isResultVisible =
                                              true;
                                        _debounce =
                                            Timer(Duration(seconds: 2), () {
                                          debugPrint(
                                              "Memulai proses translasi...");
                                          translationProcess(_sourceLanguage,
                                              _targetLanguage, _keywordTranslation
                                                .text);
                                        });
                                      } else {
                                        // Jika value kosong, kembalikan keadaan seperti semula
                                        setState(() {
                                          translationResult = '';
                                          isResultVisible = false;
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(flex: 1, child: SizedBox())
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _toggleSpeech() {
    setState(() {
      isRecordingSpeech = !isRecordingSpeech;
      micButtonColor =
          isRecordingSpeech ? Colors.white : Colors.indigo.shade800;
      micIconColor = isRecordingSpeech ? Colors.indigo.shade800 : Colors.white;
      // isResultVisible ? isResultVisible = false : isResultVisible = true;
    });
  }

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    }
  }

  Widget listLanguage(String lang) {
    Map<String, String> flagIcons = {
      LocaleKeys.indonesian.tr(): 'assets/icons/icons8-indonesia-48.png',
      LocaleKeys.english.tr(): 'assets/icons/icons8-usa-48.png',
      LocaleKeys.japanese.tr(): 'assets/icons/icons8-japan-48.png',
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
    return '';
  }

  List<DropdownMenuItem<String>>? listTranslateLanguage(
      String source, Size size) {
    return languageList.map((bahasa) {
      print('value item $source = $bahasa');
      return DropdownMenuItem(
        value: bahasa,
        child: Container(
          padding: EdgeInsets.only(
            right: source == '1' ? 5.0 : 0.0,
            left: source == '2' ? 5.0 : 0.0,
          ),
          alignment: source == '1'
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: Text(
            bahasa,
            style: TextStyle(
              color: Colors.indigo.shade800,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
            textAlign: source == '1' ? TextAlign.end : TextAlign.start,
          ),
        ),
      );
    }).toList();
  }

  Future<void> translationProcess(TranslateLanguage sourceLang,
      TranslateLanguage targetLang, String text) async {
    if (text.isEmpty) return;

    final modelManager = OnDeviceTranslatorModelManager();

    try {
      debugPrint("Teks sebelum translasi: $text");
      debugPrint("Bahasa sumber: ${sourceLang.bcpCode}");
      debugPrint("Bahasa target: ${targetLang.bcpCode}");

      // Pastikan model sudah diunduh
      if (!await modelManager.isModelDownloaded(sourceLang.bcpCode)) {
        debugPrint("Mengunduh model bahasa: ${sourceLang.bcpCode}");
        await modelManager.downloadModel(sourceLang.bcpCode);
      }
      if (!await modelManager.isModelDownloaded(targetLang.bcpCode)) {
        debugPrint("Mengunduh model bahasa: ${targetLang.bcpCode}");
        await modelManager.downloadModel(targetLang.bcpCode);
      }

      // Inisialisasi Translator
      final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: sourceLang,
        targetLanguage: targetLang,
      );

      debugPrint("Mengirim permintaan ke API...");
      final translatedText = await onDeviceTranslator.translateText(text);
      debugPrint("Hasil translasi: $translatedText");

      if (mounted) {
        setState(() {
          translationResult = translatedText;
          isResultVisible = true;
        });
      }
    } catch (e, stacktrace) {
      debugPrint("Terjadi kesalahan saat menerjemahkan: $e");
      debugPrint("Detail error: $stacktrace");

      if (mounted) {
        setState(() {
          translationResult = "Gagal menerjemahkan";
        });
      }
    }
  }

  void changeLanguage(String selectedLanguage, bool isSource) {
    setState(() {
      if (isSource) {
        sourceLanguageItem = selectedLanguage;
        _sourceLanguage = getTranslateLanguage(selectedLanguage);
      } else {
        targetLanguageItem = selectedLanguage;
        _targetLanguage = getTranslateLanguage(selectedLanguage);
      }
    });

    print(
        'Source Language: $_sourceLanguage, Target Language: $_targetLanguage');
  }

  TranslateLanguage getTranslateLanguage(String language) {
    final languageMap = {
      LocaleKeys.english.tr(): TranslateLanguage.english,
      LocaleKeys.indonesian.tr(): TranslateLanguage.indonesian,
      LocaleKeys.japanese.tr(): TranslateLanguage.japanese,
    };

    return languageMap[language] ?? TranslateLanguage.english;
  }

  void copyToClipboard(String text) {
    print(LocaleKeys.copy_clipboard_message);
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.copy_clipboard_message.tr())),
      );
    });
  }
}
