part of 'locale_bloc.dart';

enum LocaleStatus { initial, loading, loaded, error }

class LocaleState {
  final Locale locale;
  final LocaleStatus status;
  final bool isSystemLocale;

  const LocaleState({required this.locale, this.status = LocaleStatus.initial, this.isSystemLocale = false});

  factory LocaleState.initial() => const LocaleState(locale: Locale('en', 'US'), status: LocaleStatus.initial, isSystemLocale: true);

  LocaleState copyWith({Locale? locale, LocaleStatus? status, bool? isSystemLocale}) {
    return LocaleState(locale: locale ?? this.locale, status: status ?? this.status, isSystemLocale: isSystemLocale ?? this.isSystemLocale);
  }
}
