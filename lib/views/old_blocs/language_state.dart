part of 'language_bloc.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageChanged extends LanguageState {
  final String language;

  const LanguageChanged(this.language);

  @override
  List<Object> get props => [language];
}