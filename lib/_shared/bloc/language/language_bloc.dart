import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageLoaded('es')) {
    on<LanguageEventUpdate>((event, emit) {
      emit(LanguageLoaded(event.language));
    });
  }
}
