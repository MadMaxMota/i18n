# Flutter Internationalization

A scalable and maintainable internationalization (i18n) system built with Flutter and Dart.

This project demonstrates how to build a custom translation system with YAML-based translation files, dynamic language switching, device locale detection, asynchronous translation loading, and locale resolution.

## 🎥 Demo

[▶️ Watch the demo](./demo.mp4)

## ✨ Features

* 🌎 Multiple language support
* 🔄 Dynamic language switching
* 📱 Automatic device locale detection
* 📄 YAML-based translation files
* ⚡ Asynchronous translation loading
* 🌐 Locale resolution
* 🧩 Centralized translation management
* 🏗️ Separation between translations and application logic
* 📈 Easy to extend with new languages

## 🛠️ Technologies

* **Flutter**
* **Dart**
* **YAML**
* **Internationalization (i18n)**

## 📁 Project Structure

```text
lib/
└── assets/
    └── i18n/
        ├── en_US.yaml
        ├── es_ES.yaml
        ├── pt_BR.yaml
        │
        └── translate/
            ├── i18n_translate.dart
            ├── translate_helper.dart
            ├── translation_asset_loader.dart
            └── yaml_ultis.dart
```

### Translation files

The YAML files contain the localized content:

```text
assets/i18n/
├── en_US.yaml
├── es_ES.yaml
└── pt_BR.yaml
```

### Translation system

The `translate` directory contains the core components responsible for loading, managing, and accessing translations:

* `i18n_translate.dart` — Provides the translation API.
* `translate_helper.dart` — Provides locale and translation management helpers.
* `translation_asset_loader.dart` — Loads translation assets asynchronously.
* `yaml_ultis.dart` — Provides utilities for handling YAML translation data.

## 🌐 Translation Files

Translations are stored in YAML files, keeping localized content separate from the application code.

For example, `en_US.yaml`:

```yaml
welcome:
  title: "Welcome"
  description: "Welcome to the application"
```

The same keys can be used in `pt_BR.yaml`:

```yaml
welcome:
  title: "Bem-vindo"
  description: "Bem-vindo ao aplicativo"
```

And in `es_ES.yaml`:

```yaml
welcome:
  title: "Bienvenido"
  description: "Bienvenido a la aplicación"
```

Using consistent translation keys across languages makes it easier to maintain localized content without changing the application's business logic.

## 📱 Locale Detection

The system can detect the device locale and resolve it against the application's supported locales.

For example, if the device provides:

```text
pt_BR
```

and `pt_BR` is supported, that locale is selected directly.

If the exact locale is not supported, the system checks whether another supported locale uses the same language:

```text
Device Locale
      ↓
    pt_BR
      ↓
Is the locale supported?
   ↙         ↘
 Yes          No
  ↓            ↓
Use it    Search by language
              ↓
       Language available?
          ↙       ↘
        Yes        No
         ↓          ↓
    Use matching   Use first
      locale       supported locale
```

## 🌐 Locale Resolution

The locale resolution logic is responsible for finding the most appropriate supported locale for a requested locale.

The process first checks whether the complete locale is supported:

```dart
if (_isSupported(locale)) {
  return locale;
}
```

If the exact locale is not supported, it searches for a supported locale with the same language:

```dart
return supportedLocalesList.firstWhere(
  (Locale supportedLocale) =>
      supportedLocale.languageCode == locale.languageCode,
  orElse: () => supportedLocalesList.first,
);
```

The matching process can therefore be summarized as:

```text
Exact Locale
     ↓
Supported?
   ↙     ↘
 Yes      No
  ↓        ↓
Return   Same language?
           ↙      ↘
         Yes       No
          ↓         ↓
       Return    First supported
       locale       locale
```

This is **locale resolution**, rather than translation fallback.

## 🔄 Language Switching

The application can change the current locale dynamically.

```dart
TranslateHelper.setLocale(
  const Locale('pt', 'BR'),
);
```

Translations can then be accessed through their keys:

```dart
Text('welcome.title'.tr)
```

This keeps translation access independent from the application's business logic.

## 🚀 Adding a New Language

To add a new language:

1. Create a new YAML translation file.
2. Use the same translation keys as the existing languages.
3. Add the locale to the supported locales.
4. The translation system can then load the new language asynchronously.

For example:

```text
assets/i18n/
├── en_US.yaml
├── es_ES.yaml
├── pt_BR.yaml
└── fr_FR.yaml
```

The translation keys should remain consistent across all language files.

## 🏗️ Architecture

The translation flow can be represented as:

```text
YAML Translation Files
        ↓
Translation Asset Loader
        ↓
Translation Management
        ↓
Translation Helper / API
        ↓
Flutter UI
```

Locale resolution is handled separately to determine which supported locale should be used by the application.

## 🎯 Goals

This project was created to explore a custom internationalization architecture in Flutter, focusing on:

* Maintainability
* Scalability
* Separation of concerns
* Asynchronous resource loading
* Locale resolution
* Dynamic locale management
* Clean and reusable APIs
* YAML-based translation management

## 📌 Why a Custom i18n Solution?

Instead of coupling the application to a third-party internationalization package, this project explores how an i18n system can be designed and controlled internally.

This provides greater control over:

* Translation loading
* Translation file structure
* Locale resolution
* Locale management
* Translation API design
* Application architecture

The project is also intended as a practical exploration of how a custom i18n solution can be structured in a Flutter application.

## 📄 License

This project is available for educational and demonstration purposes.
