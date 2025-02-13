import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf_translator_app_test/views/blocs/textrecognition_event.dart';

class TextRecognitionBloc extends Bloc<TextRecognitionEvent, String> {
  TextRecognitionBloc() : super("") {
    // Menambahkan event handler untuk StartTextRecognition
    on<StartTextRecognition>((event, emit) async {
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      try {
        final inputImage = InputImage.fromFilePath(event.imagePath);
        final recognizedText = await textRecognizer.processImage(inputImage);
        emit(recognizedText.text);
      } catch (e) {
        emit('Error: $e');
      }
    });

    // Menambahkan event handler untuk ZoomChanged
    on<ZoomChanged>((event, emit) {
      emit('Zoom level: ${event.zoomLevel}');
    });
  }
}
