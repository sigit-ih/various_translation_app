import 'package:bubble/bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_translator_app_test/translations/locale_keys.g.dart';
import 'package:pdf_translator_app_test/utilities/sharedpreferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class WordTranslationScreen extends StatefulWidget {
  const WordTranslationScreen({super.key});

  @override
  State<WordTranslationScreen> createState() => _WordTranslationScreenState();
}

class _WordTranslationScreenState extends State<WordTranslationScreen> {
  List<String> languageList = [
    LocaleKeys.english.tr(),
    LocaleKeys.indonesian.tr(),
    LocaleKeys.japanese.tr()
  ];
  // Speech to text
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool isRecordingSpeech = false;
  String _lastWords = '';
  Color micButtonColor = Colors.indigo.shade800;
  Color micIconColor = Colors.white;
  String language = 'English';

  bool isResultVisible = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    listenForPermissions();
    SharedPreferencesHelper.readLanguage().then((value) {
      setState(() {
        language = value;
      });
    });

    print(languageList);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String item1 = language;
    String item2 = (language != 'English')
        ? LocaleKeys.english.tr()
        : LocaleKeys.indonesian.tr();

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
                                padding: BubbleEdges.all(10),
                                margin: BubbleEdges.only(top: 15, right: 5),
                                alignment: Alignment.topRight,
                                nip: BubbleNip.rightTop,
                                color: Color.fromRGBO(225, 255, 199, 1.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '~ $item1',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextField(
                                      maxLines: 7,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      maxLength: 300,
                                      onChanged: (value) {},
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/carbon-design-system/32/copy.svg',
                                          colorFilter: ColorFilter.mode(
                                              Colors.red, BlendMode.srcIn),
                                          width: 25,
                                          height: 25,
                                        ),
                                        SizedBox(width: 12),
                                        SvgPicture.asset(
                                          'assets/icons/carbon-design-system/32/volume--up--filled.svg',
                                          colorFilter: ColorFilter.mode(
                                              Colors.red, BlendMode.srcIn),
                                          width: 25,
                                          height: 25,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            listLanguage(item1),
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
                            listLanguage(item2),
                            SizedBox(width: 10),
                            Expanded(
                              child: Bubble(
                                padding: BubbleEdges.all(10),
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
                                            '~ $item2',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                    if (isResultVisible)
                                      Column(
                                        children: [
                                          TextField(
                                            maxLines: 7,
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              counterText: '',
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                            maxLength: 300,
                                            onChanged: (value) {},
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/carbon-design-system/32/copy.svg',
                                                colorFilter: ColorFilter.mode(
                                                    Colors.blue,
                                                    BlendMode.srcIn),
                                                width: 25,
                                                height: 25,
                                              ),
                                              SizedBox(width: 12),
                                              SvgPicture.asset(
                                                'assets/icons/carbon-design-system/32/volume--up--filled.svg',
                                                colorFilter: ColorFilter.mode(
                                                    Colors.blue,
                                                    BlendMode.srcIn),
                                                width: 25,
                                                height: 25,
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
                            child: SizedBox(
                              width: size.width,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    iconSize: 0.0,
                                    elevation: 2,
                                    isExpanded: true,
                                    value: item1,
                                    underline:
                                        Container(color: Colors.transparent),
                                    dropdownColor: Colors.white,
                                    items: listTranslateLanguage('1'),
                                    onChanged: (value) {
                                      print('value onChanged = $value');
                                      print(
                                          'locale awal = ${LocaleKeys.dictionary.tr()}');
                                      setState(() {
                                        print('onchange item1 before = $item1');
                                        item1 = value.toString();
                                        print('onchange item1 after = $item1');
                                      });
                                    },
                                  ),
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
                            child: SizedBox(
                              width: size.width,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5),
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                      iconSize: 0.0,
                                      elevation: 2,
                                      isExpanded: true,
                                      value: item2,
                                      underline:
                                          Container(color: Colors.transparent),
                                      dropdownColor: Colors.white,
                                      items: listTranslateLanguage('2'),
                                      onChanged: (value) {
                                        print('value onChanged = $value');
                                        print(
                                            'locale awal = ${LocaleKeys.dictionary.tr()}');
                                        setState(() {
                                          print(
                                              'onchange item2 before = $item2');
                                          item2 = value.toString();
                                          print(
                                              'onchange item2 after = $item2');
                                        });
                                      }),
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
      isResultVisible ? isResultVisible = false : isResultVisible = true;
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
    if (lang == 'Bahasa Indonesia') {
      return 'id';
    } else if (lang == 'English') {
      return 'en';
    } else if (lang == '日本語') {
      return 'ja';
    }
    return '';
  }

  List<DropdownMenuItem<String>>? listTranslateLanguage(String source) {
    if (source == '1') {
      return languageList.map((bahasa) {
        print('value item 1 = $bahasa');
        return DropdownMenuItem(
          value: bahasa,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              bahasa,
              style: TextStyle(
                  color: Colors.indigo.shade800,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        );
      }).toList();
    } else {
      return languageList.map((bahasa) {
        print('value item 2 = $bahasa');
        return DropdownMenuItem(
          value: bahasa,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              bahasa,
              style: TextStyle(
                  color: Colors.indigo.shade800,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
        );
      }).toList();
    }
  }
}
