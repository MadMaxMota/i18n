part of 'i18n_translate.dart';

class TranslationAssetLoader {
  final String dictionaryId;
  final String basePath;
  final Locale? locale;

  TranslationAssetLoader({this.dictionaryId = 'default', this.basePath = 'lib/assets/i18n', this.locale = const Locale('en', 'US')});

  TranslationAssetLoader copyWith({String? dictionaryId, String? basePath, Locale? locale}) => TranslationAssetLoader(
    dictionaryId: dictionaryId ?? this.dictionaryId,
    basePath: basePath ?? this.basePath,
    locale: locale ?? this.locale,
  );

  Future<Map<String, dynamic>> load() async {
    final YamlUtils yamlUtils = YamlUtils();
    final Locale effectiveLocale = _resolveLocale(locale);
    return yamlUtils.loadYamlFromPath('$basePath/${effectiveLocale.toString()}.yaml');
  }

  Locale _resolveLocale(Locale? loaderLocale) => loaderLocale ?? WidgetsBinding.instance.platformDispatcher.locale;
}
