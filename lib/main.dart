import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n/assets/i18n/translate/i18n_translate.dart';
import 'package:i18n/presentation/controller/locale_bloc.dart';
import 'package:i18n/presentation/ui/language_switcher_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const Locale initialLocale = Locale('en', 'US');

  final TranslationAssetLoader loader = TranslationAssetLoader(
    locale: initialLocale,
    dictionaryId: '${initialLocale.languageCode}_${initialLocale.countryCode}',
  );

  await I18nTranslate.initialize(loader: loader);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocaleBloc()..add(LocaleSystemRequestedEvent()),
      child: BlocConsumer<LocaleBloc, LocaleState>(
        buildWhen: (LocaleState previous, LocaleState current) => previous.locale != current.locale,

        listenWhen: (LocaleState previous, LocaleState current) => previous.locale != current.locale,

        listener: (context, state) async {
          await context.changeLocale(state.locale);
        },

        builder: (context, state) {
          return MaterialApp(
            locale: state.locale,
            supportedLocales: LocaleBloc.supportedLocalesList,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.translate('app.title')),
        actions: const [LanguageSwitcher()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.translate('home.counter_message')),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: context.translate('home.increment'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
