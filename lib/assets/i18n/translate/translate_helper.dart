part of 'i18n_translate.dart';

class LocaleConverter {
  const LocaleConverter._();

  static Locale? toMaterial(ui.Locale? dartUiLocale) {
    if (dartUiLocale == null) return null;
    final countryCode = dartUiLocale.countryCode;
    return (countryCode == null || countryCode.isEmpty)
        ? Locale(dartUiLocale.languageCode)
        : Locale(dartUiLocale.languageCode, countryCode);
  }

  static ui.Locale toDartUi(Locale materialLocale) => ui.Locale(materialLocale.languageCode, materialLocale.countryCode);
}

extension BuildContextI18n on BuildContext {
  I18nTranslate get _i18n => I18nTranslate.instance;

  String translate(String key, {String? dictionaryId, Map<String, String>? parameters}) =>
      _i18n.translateIdiom(key, dictionaryId: dictionaryId, parameters: parameters);

  Future<void> changeLocale(ui.Locale locale) => I18nTranslate.changeLocale(locale);

  String formatCurrency(double amount, {String? format, ui.Locale? locale}) =>
      _i18n.translateCurrency(amount, format: format ?? I18nDefaults.currencyFormat, locale: locale);

  String formatDate(DateTime date, {String? format, ui.Locale? locale}) =>
      _i18n.translateDate(date, format: format ?? I18nDefaults.dateFormat, locale: LocaleConverter.toMaterial(locale));
}
