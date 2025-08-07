// lib/bloc/theme_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void toggle() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
