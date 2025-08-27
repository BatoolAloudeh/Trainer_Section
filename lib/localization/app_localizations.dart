import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'app_localizations_delegate.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {};

  Future<void> load() async {
    final jsonString = await rootBundle.loadString('lang/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((k, v) => MapEntry(k, v.toString()));
  }

  String translate(String key) {
    // if the map isn’t loaded yet, or the key isn’t found, fall back to the key itself
    return _localizedStrings[key] ?? key;
  }

  /// should be true for English, false for Arabic
  bool get isEnLocale => locale.languageCode == 'en';
}
