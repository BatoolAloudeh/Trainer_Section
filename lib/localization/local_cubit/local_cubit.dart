import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _languageKey = 'app_language';

  LocaleCubit() : super(const Locale('en')) {
    _loadLocale();
  }

  void toEnglish() {
    emit(const Locale('en'));
    _saveLocale('en');
  }

  void toArabic() {
    emit(const Locale('ar'));
    _saveLocale('ar');
  }

  Future<void> _saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    emit(Locale(languageCode));
  }

  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageKey);
    emit(const Locale('en'));
  }
}

/*
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  void toEnglish() => emit(const Locale('en'));
  void toArabic() => emit(const Locale('ar'));
}
*/
