import 'package:flutter/material.dart';

/// App language configuration. Texts live in `assets/lang/{ar,en}.json`.
abstract final class LocalizationManager {
  static const String translationsPath = 'assets/lang';

  /// Arabic is the default and the fallback for any missing English text.
  static const Locale defaultLocale = Locale('ar');

  static const List<Locale> supportedLocales = [Locale('ar'), Locale('en')];
}
