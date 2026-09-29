part of 'locale_bloc.dart';

abstract class LocaleEvent {}

class LocaleChangedEvent extends LocaleEvent {
  final Locale locale;

  LocaleChangedEvent({required this.locale});
}

class LocaleSystemRequestedEvent extends LocaleEvent {}
