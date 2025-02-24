import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf_translator_app_test/translations/locale_keys.g.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  bool isPlaying = false; // Status suara

  TextToSpeechService() {
    _flutterTts.setStartHandler(() {
      isPlaying = true;
      print("TTS mulai berbicara...");
    });

    _flutterTts.setCompletionHandler(() {
      isPlaying = false;
      print("TTS selesai berbicara...");
    });

    _flutterTts.setCancelHandler(() {
      isPlaying = false;
      print("TTS dibatalkan...");
    });

    _flutterTts.awaitSpeakCompletion(true); // Tunggu hingga selesai

    // Menampilkan bahasa yang tersedia saat inisialisasi
    _flutterTts.getLanguages.then((languages) {
      print("Available languages: $languages");
    });
  }

  Future<void> speak(String text, String langCode) async {
    if (isPlaying) {
      print("TTS sedang berbicara, hentikan dulu sebelum memulai.");
      return;
    }

    // Menampilkan bahasa yang tersedia sebelum berbicara
    // String currentLang = await _flutterTts.getLanguages;
    // print("Available languages: $currentLang");

    await _flutterTts.setLanguage(localeCode(langCode));
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.8); // Kecepatan lebih lancar
    await _flutterTts.setVolume(1.0); // Volume maksimal

    await _flutterTts.setEngine("android_synthesis"); // Mode khusus Android

    await _flutterTts.speak(text);
  }

  String localeCode(String lang) {
    const locales = {
      LocaleKeys.english: 'en-US',
      LocaleKeys.indonesian: 'id-ID',
      LocaleKeys.japanese: 'ja-JP',
    };

    return locales.entries
        .firstWhere(
          (entry) => entry.key.tr() == lang,
          orElse: () => MapEntry(LocaleKeys.english, 'en-US'),
        )
        .value;
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  bool isSpeaking() {
    return isPlaying;
  }
}
