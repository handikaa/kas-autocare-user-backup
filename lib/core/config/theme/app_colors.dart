// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  static final light = _LightColors();

  static final dark = _DarkColors();

  static final common = _CommonColors();
}

class _LightColors {
  final Color primary = const Color(0xFF279CB4);
  final Color darkprimary = const Color.fromARGB(255, 35, 140, 161);
  final Color primary30 = const Color(0xFF279CB4).withOpacity(0.3);
  final Color secondary = const Color(0xFF000000);

  final Color borderPrimary = Color(0xFF279CB4).withOpacity(0.7);

  final Color background = const Color(0xFFF3F9FF);
  final Color starYellow = const Color(0xFFFFB400);
  final Color success40 = const Color(0xFF32D583);
  final Color mainBlue = const Color.fromARGB(255, 0, 87, 227);
  final Color surface = const Color.fromARGB(255, 162, 128, 128);
  final Color textPrimary = const Color(0xFF1C1C1C);
  final Color textSecondary = const Color(0xFF707070);
  final Color error = const Color(0xFFE53935);
}

class _DarkColors {
  final Color primary = const Color(0xFFFFFFFF);
  final Color secondary = const Color(0xFF9E9E9E);
  final Color background = const Color(0xFF121212);
  final Color surface = const Color(0xFF1E1E1E);
  final Color textPrimary = const Color(0xFFFFFFFF);
  final Color textSecondary = const Color(0xFFBDBDBD);
  final Color error = const Color(0xFFEF5350);
}

class _CommonColors {
  final Color black = const Color(0xFF000000);
  final Color white = const Color(0xFFFFFFFF);
  final Color lightOrange = const Color(0xFFFF9800);
  final Color solidGrey = Colors.grey;
  final Color grey200 = const Color(0xFFEEEEEE);
  final Color grey300 = const Color(0xFFD5D7DA);
  final Color grey400 = const Color(0xFFA4A7AE);
  final Color grey500 = const Color.fromARGB(255, 149, 151, 157);

  final Color appblue = Colors.blue;
  final Color appOrange = Colors.orange;
  final Color appTeal = Colors.teal;
  final Color appAmber = Colors.amber;
  final Color appRedAccent = Colors.redAccent;
}
