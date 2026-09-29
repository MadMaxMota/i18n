import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:i18n/assets/i18n/translate/yaml_ultis.dart';
import 'package:intl/intl.dart';

part 'translation_asset_loader.dart';
part 'translate_helper.dart';

class I18nDefaults {
  const I18nDefaults._();

  static const String dictionaryId = 'default';
  static const String currencyFormat = 'R\$ #,##0.00';
  static const String dateFormat = 'EEE, dd/MM/yyyy';
}

class I18nTranslate {
  I18nTranslate._internal();

  static final I18nTranslate _instance = I18nTranslate._internal();
  static I18nTranslate get instance => _instance;

  final Map<String, Map<String, dynamic>> _dictionariesMap = {};
  TranslationAssetLoader? _defaultLoader;
  String _activeDictionaryId = I18nDefaults.dictionaryId;

  int _loadToken = 0;
  bool get _isInitialized => _defaultLoader != null;
  bool get isInitialized => _isInitialized;

  static Future<void> initialize({required TranslationAssetLoader loader}) {
    return _instance._loadAndActivate(loader);
  }

  static Future<void> changeLocale(ui.Locale newLocale) {
    final TranslationAssetLoader? loader = _instance._defaultLoader;
    if (loader == null) {
      throw StateError('I18nTranslate not initialized. Call I18nTranslate.initialize first.');
    }

    return _instance._loadAndActivate(loader.copyWith(locale: newLocale));
  }

  Future<void> _loadAndActivate(TranslationAssetLoader loader) async {
    final int token = ++_loadToken;
    final Map<String, dynamic> contentMap = await loader.load();

    if (token != _loadToken) return;

    _dictionariesMap[loader.dictionaryId] = contentMap;
    _activeDictionaryId = loader.dictionaryId;
    _defaultLoader = loader;
  }

  String translateIdiom(String key, {String? dictionaryId, Map<String, String>? parameters}) {
    if (!_isInitialized) return key;

    final Map<String, dynamic>? dictionaryMap = _selectDictionary(dictionaryId);
    if (dictionaryMap == null) return key;

    final dynamic value = _resolvePath(dictionaryMap, key.split('.'));
    if (value == null) return key;

    return _applyParameters(value.toString(), parameters);
  }

  Map<String, dynamic>? _selectDictionary(String? id) {
    return _dictionariesMap[id ?? _activeDictionaryId];
  }

  dynamic _resolvePath(Map<String, dynamic> dictionary, List<String> path) {
    dynamic current = dictionary;

    for (var i = 0; i < path.length - 1; i++) {
      if (current is! Map) return null;
      current = current[path[i]];
    }

    if (current is! Map) return null;
    return current[path.last] ?? dictionary[path.last];
  }

  String _applyParameters(String template, Map<String, String>? parameters) {
    if (parameters == null || parameters.isEmpty) return template;

    return template.replaceAllMapped(RegExp(r'\{(\w+)\}'), (match) => parameters[match.group(1)] ?? match.group(0)!);
  }

  String translateCurrency(double amount, {String format = I18nDefaults.currencyFormat, ui.Locale? locale}) {
    final Locale target = locale ?? WidgetsBinding.instance.platformDispatcher.locale;
    return NumberFormat(format, target.toString()).format(amount);
  }

  String translateDate(DateTime date, {String format = I18nDefaults.dateFormat, Locale? locale}) {
    final Locale target = locale ?? WidgetsBinding.instance.platformDispatcher.locale;
    return DateFormat(format, target.toString()).format(date);
  }
}
