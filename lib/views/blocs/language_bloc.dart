import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdf_translator_app_test/utilities/sharedpreferences.dart';

// Event
abstract class LanguageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadLanguageEvent extends LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final String language;
  ChangeLanguageEvent(this.language);

  @override
  List<Object> get props => [language];
}

// State
class LanguageState extends Equatable {
  final String language;
  const LanguageState(this.language);

  @override
  List<Object> get props => [language];
}

// Bloc
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState('English')) {
    on<LoadLanguageEvent>((event, emit) async {
      String lang = await SharedPreferencesHelper.readLanguage();
      emit(LanguageState(lang));
    });

    on<ChangeLanguageEvent>((event, emit) async {
      await SharedPreferencesHelper.saveLanguage(event.language);
      emit(LanguageState(event.language));
    });
  }
}
