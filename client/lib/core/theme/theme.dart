// ignore_for_file: prefer_const_constructors

import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 3));

  static final darkThemeMode = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Pallete.backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: _inputBorder(Pallete.borderColor),
          focusedBorder: _inputBorder(Pallete.gradient2)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Pallete.backgroundColor));
}
