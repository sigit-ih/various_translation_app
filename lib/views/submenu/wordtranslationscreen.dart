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
  // Speech to text
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool isRecordingSpeech = false;
  Color micButtonColor = Colors.indigo.shade800;
  Color micIconColor = Colors.white;

  // Shared preference
  String language = 'English';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    print('isRecordingSpeech = $isRecordingSpeech');
    listenForPermissions();

    // ambil username dari SharedPreferences
    SharedPreferencesHelper.readLanguage().then((value) {
      setState(() {
        language = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('Simple Translator = ${LocaleKeys.translation.tr()}');
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.translation.tr()),
        backgroundColor: Colors.indigo[800],
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          color: Colors.indigo[800],
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 5,
                child: Container(
                  height: size.height,
                  width: size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: size.width, // Perbesar width Bubble
                              child: Bubble(
                                padding: BubbleEdges.all(10),
                                margin: BubbleEdges.only(top: 15, right: 5),
                                alignment: Alignment.topRight,
                                nip: BubbleNip.rightTop,
                                color: Color.fromRGBO(225, 255, 199, 1.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      language,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextField(
                                      maxLines: 8,
                                      style:TextStyle(fontSize:14),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        enabledBorder: InputBorder.none, // Pastikan tidak ada border saat tidak aktif
                                        focusedBorder: InputBorder.none,
                                      ),
                                      maxLength: 300,
                                      onChanged: (value) {},
                                    ),
                                    SizedBox(
                                      width: size.width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/carbon-design-system/32/copy.svg',
                                            colorFilter:
                                                ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                                            width: 25,
                                            height: 25,
                                          ),
                                          SizedBox(width: 10),
                                          SvgPicture.asset(
                                            'assets/icons/carbon-design-system/32/microphone--filled.svg',
                                            colorFilter:
                                                ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                                            width: 25,
                                            height: 25,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40, // Batasi ukuran agar tidak makan tempat
                          child: listLanguage(language),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 5,
                  child: Container(
                    height: size.height,
                    width: size.width,
                    color: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // TextField(
                            //   maxLines: 11,
                            //   // expands: true,
                            //   decoration: InputDecoration(
                            //     floatingLabelBehavior:
                            //         FloatingLabelBehavior.always,
                            //     alignLabelWithHint: true,
                            //     contentPadding: EdgeInsets.all(10),
                            //     enabledBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(
                            //           color: Colors.blue, width: 2.0),
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(11)),
                            //     ),
                            //     labelText: 'Default TextField 2',
                            //     labelStyle: TextStyle(
                            //         color: Colors.blue,
                            //         fontWeight: FontWeight.bold),
                            //     filled: true,
                            //     fillColor: Colors.grey.shade200,
                            //     counterText: '',
                            //   ),
                            //   maxLength: 120,
                            //   onChanged: (value) {},
                            // ),
                          ]),
                    ),
                  )),
              Flexible(
                flex: 2,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.green,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: micButtonColor,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                        ),
                        onPressed: () {
                          // _speechToText.isNotListening ? _startListening : _stopListening;
                          setState(() {
                            if (isRecordingSpeech == true) {
                              print(
                                  'isRecordingSpeech awal = $isRecordingSpeech');
                              print('_speechEnabled awal = $isRecordingSpeech');
                              isRecordingSpeech = false;
                              micButtonColor = Colors.indigo.shade800;
                              micIconColor = Colors.white;
                              print(
                                  'Toggle true to false, isRecordingSpeech = $isRecordingSpeech');
                              print(
                                  '_speechEnabled akhir = $isRecordingSpeech');
                            } else {
                              print(
                                  'isRecordingSpeech awal = $isRecordingSpeech');
                              print('_speechEnabled awal = $isRecordingSpeech');
                              isRecordingSpeech = true;
                              micButtonColor = Colors.white;
                              micIconColor = Colors.indigo.shade800;
                              print(
                                  'Toggle false to true, isRecordingSpeech = $isRecordingSpeech');
                              print(
                                  '_speechEnabled akhir = $isRecordingSpeech');
                            }
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/icons/carbon-design-system/32/microphone--filled.svg',
                          colorFilter:
                              ColorFilter.mode(micIconColor, BlendMode.srcIn),
                          width: 75,
                          height: 75,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                ]),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
    print('isRecordingSpeech initSpeech = $_speechEnabled');
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.provisional:
        break;
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  Image? listLanguage(String lang) {
    if (lang == 'Indonesia') {
      return Image.asset(
        'assets/icons/icons8-indonesia-48.png',
        width: 40,
        height: 40,
      );
    } else if (lang == 'English') {
      return Image.asset(
        'assets/icons/icons8-usa-48.png',
        width: 40,
        height: 40,
      );
    } else if (lang == '日本語') {
      return Image.asset(
        'assets/icons/icons8-japan-48.png',
        width: 40,
        height: 40,
      );
    }
    return null;
  }
}
