part of 'language_bloc.dart';

abstract class LanguageState extends Equatable {
  final String language;
  const LanguageState(this.language);

  @override
  List<Object> get props => [language];
}

class LanguageLoaded extends LanguageState {
  @override
  const LanguageLoaded(super.language);

  @override
  List<Object> get props => [language];
}
