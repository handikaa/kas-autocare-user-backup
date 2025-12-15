// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.light.primary,
    scaffoldBackgroundColor: AppColors.light.background,
    cardColor: AppColors.light.surface,
    colorScheme: ColorScheme.light(
      primary: AppColors.light.primary,
      secondary: AppColors.light.secondary,
      background: AppColors.light.background,
      surface: AppColors.light.surface,
      error: AppColors.light.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: AppColors.light.textPrimary,
      onSurface: AppColors.light.textPrimary,
      onError: Colors.white,
    ),

    // 👉 warna default teks
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.light.textPrimary),
      bodyMedium: TextStyle(color: AppColors.light.textSecondary),
    ),

    // 👉 AppBar + icon di AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.light.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // 👉 warna default Icon() (contoh Icon(Icons.arrow_forward_ios_sharp))
    iconTheme: IconThemeData(color: AppColors.light.textPrimary),

    // 👉 warna default CircularProgressIndicator, LinearProgressIndicator, dll
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.light.primary,
    ),

    // 👉 warna cursor, block seleksi teks, dan "handle" (plus efek paste/copy)
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.light.primary,
      selectionColor: AppColors.light.primary.withOpacity(0.25),
      selectionHandleColor: AppColors.light.primary,
    ),

    // 👉 ElevatedButton default
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.light.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(3),
        shadowColor: const WidgetStatePropertyAll(Colors.black26),
      ),
      textStyle: const TextStyle(color: Colors.black, fontSize: 14),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.dark.primary,
    scaffoldBackgroundColor: AppColors.dark.background,
    cardColor: AppColors.dark.surface,
    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.primary,
      secondary: AppColors.dark.secondary,
      background: AppColors.dark.background,
      surface: AppColors.dark.surface,
      error: AppColors.dark.error,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onBackground: AppColors.dark.textPrimary,
      onSurface: AppColors.dark.textPrimary,
      onError: Colors.black,
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.dark.textPrimary),
      bodyMedium: TextStyle(color: AppColors.dark.textSecondary),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.dark.surface,
      foregroundColor: AppColors.dark.textPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.dark.textPrimary),
    ),

    // Icon default di dark mode
    iconTheme: IconThemeData(color: AppColors.dark.textPrimary),

    // Progress indicator default di dark mode
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.dark.primary,
    ),

    // Seleksi teks & cursor di dark mode
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.dark.primary,
      selectionColor: AppColors.dark.primary.withOpacity(0.4),
      selectionHandleColor: AppColors.dark.primary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.dark.primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.grey[900]),
      ),
      textStyle: const TextStyle(color: Colors.white),
    ),
  );
}
