import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i18n/presentation/controller/locale_bloc.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  static final Map<Locale, String> _labels = {
    Locale('pt', 'BR'): 'Português',
    Locale('es', 'ES'): 'Español',
    Locale('en', 'US'): 'English',
  };

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LocaleBloc>(context);
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (locale) => bloc.add(LocaleChangedEvent(locale: locale)),
      itemBuilder: (context) => _labels.entries.map((e) => PopupMenuItem<Locale>(value: e.key, child: Text(e.value))).toList(),
    );
  }
}
