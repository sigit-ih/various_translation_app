import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// EVENTS
abstract class DictionaryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchWord extends DictionaryEvent {
  final String word;
  final String langFrom;
  final String langTo;

  SearchWord(this.word, this.langFrom, this.langTo);

  @override
  List<Object> get props => [word, langFrom, langTo];
}

// STATES
abstract class DictionaryState extends Equatable {
  @override
  List<Object> get props => [];
}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionaryLoaded extends DictionaryState {
  final String word;
  final String translation;
  final List<String> definitions;

  DictionaryLoaded(this.word, this.translation, this.definitions);

  @override
  List<Object> get props => [word, translation, definitions];
}

class DictionaryError extends DictionaryState {
  final String message;
  DictionaryError(this.message);

  @override
  List<Object> get props => [message];
}

// BLOC
class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  DictionaryBloc() : super(DictionaryInitial()) {
    on<SearchWord>((event, emit) async {
      emit(DictionaryLoading());

      try {
        // API untuk definisi bahasa Inggris
        String dictionaryApi =
            "https://api.dictionaryapi.dev/api/v2/entries/en/${event.word}";
        final dictResponse = await http.get(Uri.parse(dictionaryApi));

        List<String> definitions = [];
        if (dictResponse.statusCode == 200) {
          final dictData = json.decode(dictResponse.body);
          for (var meaning in dictData[0]["meanings"]) {
            for (var def in meaning["definitions"]) {
              definitions.add(def["definition"]);
            }
          }
        }

        // API untuk terjemahan bahasa
        String translateApi =
            "https://api.mymemory.translated.net/get?q=${event.word}&langpair=${event.langFrom}|${event.langTo}";
        final translateResponse = await http.get(Uri.parse(translateApi));
        String translation = event.word;

        if (translateResponse.statusCode == 200) {
          final translateData = json.decode(translateResponse.body);
          translation = translateData["responseData"]["translatedText"];
        }

        emit(DictionaryLoaded(event.word, translation, definitions));
      } catch (e) {
        emit(DictionaryError("Gagal memuat data."));
      }
    });
  }
}
