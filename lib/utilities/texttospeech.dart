import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  bool isPlaying = false; // Status suara

  TextToSpeechService() {
    // Event handler untuk mengatur status suara
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
  }

  Future<void> speak(String text) async {
    if (isPlaying) {
      print("TTS sedang berbicara, hentikan dulu sebelum memulai.");
      return;
    }

    await _flutterTts.setLanguage("id-ID"); // Bahasa Indonesia
    await _flutterTts.setPitch(1.0); // Nada suara (0.5 - 2.0)
    await _flutterTts.setSpeechRate(0.5); // Kecepatan bicara (0.0 - 1.0)
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  bool isSpeaking() {
    return isPlaying;
  }
}
