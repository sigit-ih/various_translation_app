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
  "version": "Version",
  "translation": "Translation",
  "title": "Various Translations",
  "text_recognition_translation": "Text Recognition and Translation",
  "ocr_translation": "OCR Translation",
  "japanese": "Japanese",
  "indonesian": "Indonesian",
  "english": "English",
  "document_translation": "Document Translation",
  "dictionary": "Dictionary",
  "about": "About",
  "translation_process": "Waiting for Translation...",
  "copy_clipboard_message": "Text was successfully copied to the clipboard"
};
static const Map<String,dynamic> _id = {
  "version": "Versi",
  "translation": "Terjemahan",
  "title": "Berbagai Terjemahan",
  "text_recognition_translation": "Pengenalan dan Terjemahan Teks",
  "ocr_translation": "Terjemahan OCR",
  "japanese": "Jepang",
  "indonesian": "Indonesia",
  "english": "Inggris",
  "document_translation": "Terjemahan Dokumen",
  "dictionary": "Kamus",
  "about": "Tentang",
  "translation_process": "Menunggu Translasi...",
  "copy_clipboard_message": "Teks berhasil disalin ke clipboard"
};
static const Map<String,dynamic> _ja = {
  "version": "バージョン",
  "translation": "翻訳",
  "title": "さまざまな翻訳",
  "text_recognition_translation": "テキストの認識と翻訳",
  "ocr_translation": "OCR翻訳",
  "japanese": "日本語",
  "indonesian": "インドネシア語",
  "english": "英語",
  "document_translation": "文書翻訳",
  "dictionary": "辞書",
  "about": "について",
  "translation_process": "翻訳を待っています...",
  "copy_clipboard_message": "テキストはクリップボードに正常にコピーされました"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "id": _id, "ja": _ja};
}
