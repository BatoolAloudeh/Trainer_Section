// lib/theme/app_themes.dart
import 'package:flutter/material.dart';
// lib/theme/app_themes.dart
import 'package:flutter/material.dart';
import '../../../constant/ui/Colors/colors.dart';


class AppThemes {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.purple,
    scaffoldBackgroundColor: AppColors.w1,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.w1,
      iconTheme: IconThemeData(color: AppColors.darkBlue),
      titleTextStyle: TextStyle(color: AppColors.darkBlue, fontSize: 20),
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.purple,
      secondary: AppColors.orange,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(AppColors.purple),
      trackColor: MaterialStateProperty.all(AppColors.purple.withOpacity(0.5)),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.purple,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      elevation: 0,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.purple,
      secondary: AppColors.orange,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.purple,
        foregroundColor: Colors.white,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(AppColors.purple),
      trackColor: MaterialStateProperty.all(AppColors.purple.withOpacity(0.5)),
    ),
  );
}
