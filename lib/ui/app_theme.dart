import 'package:flutter/material.dart';

enum AppTheme {
  LIGHT,
  DARK
}

final appThemeData = {
  AppTheme.LIGHT: ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  ),
  AppTheme.DARK: ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
  ),
};