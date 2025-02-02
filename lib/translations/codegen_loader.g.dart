// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "translation": "Translation",
  "text_recognition_translation": "Text Recognition and Translation",
  "ocr_translation": "OCR Translation",
  "document_translation": "Document Translation",
  "dictionary": "Dictionary",
  "about": "About"
};
static const Map<String,dynamic> _id = {
  "translation": "Terjemahan",
  "text_recognition_translation": "Pengenalan dan Terjemahan Teks",
  "ocr_translation": "Terjemahan OCR",
  "document_translation": "Terjemahan Dokumen",
  "dictionary": "Kamus",
  "about": "Tentang"
};
static const Map<String,dynamic> _ja = {
  "about": "について",
  "dictionary": "辞書",
  "translation": "翻訳",
  "ocr_translation": "OCR翻訳",
  "document_translation": "文書翻訳",
  "text_recognition_translation": "テキストの認識と翻訳"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "id": _id, "ja": _ja};
}
