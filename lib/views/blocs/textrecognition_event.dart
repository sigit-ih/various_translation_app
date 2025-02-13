abstract class TextRecognitionEvent {}

class StartTextRecognition extends TextRecognitionEvent {
  final String imagePath;
  final String languageCode;

  StartTextRecognition({required this.imagePath, required this.languageCode});
}

class ZoomChanged extends TextRecognitionEvent {
  final double zoomLevel;

  ZoomChanged(this.zoomLevel);
}
