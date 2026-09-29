import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const List<Locale> supportedLocalesList = [Locale('en', 'US'), Locale('pt', 'BR'), Locale('es', 'ES')];

  LocaleBloc() : super(LocaleState.initial()) {
    on<LocaleChangedEvent>(_onChanged);
    on<LocaleSystemRequestedEvent>(_onSystemRequested);
  }

  void _onChanged(LocaleChangedEvent event, Emitter<LocaleState> emit) {
    if (!_isSupported(event.locale)) {
      emit(state.copyWith(status: LocaleStatus.error));
      return;
    }

    emit(state.copyWith(locale: event.locale, status: LocaleStatus.loaded, isSystemLocale: false));
  }

  void _onSystemRequested(LocaleSystemRequestedEvent event, Emitter<LocaleState> emit) {
    final Locale systemLocale = PlatformDispatcher.instance.locale;

    emit(state.copyWith(locale: _findBestMatch(systemLocale), status: LocaleStatus.loaded, isSystemLocale: true));
  }

  Locale _findBestMatch(Locale locale) {
    if (_isSupported(locale)) return locale;

    return supportedLocalesList.firstWhere(
      (Locale supportedLocale) => supportedLocale.languageCode == locale.languageCode,
      orElse: () => supportedLocalesList.first,
    );
  }

  bool _isSupported(Locale locale) {
    return supportedLocalesList.any(
      (Locale supportedLocale) =>
          supportedLocale.languageCode == locale.languageCode &&
          (supportedLocale.countryCode == null || supportedLocale.countryCode == locale.countryCode),
    );
  }
}
