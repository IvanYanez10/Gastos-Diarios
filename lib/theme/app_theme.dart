import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFF059669),
  hintColor: const Color(0xFF3F72AF),
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF059669), brightness: Brightness.light),
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
    bodyText1: TextStyle(fontSize: 16, color: Colors.black),
    subtitle1: TextStyle(fontSize: 15, color: Colors.grey),
    button: TextStyle(fontSize: 16, color: Colors.white),
    caption: TextStyle(fontSize: 16, color: Colors.grey),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF059669),
    elevation: 3.0,
    foregroundColor: Colors.white,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
