import 'dart:async';
import 'package:flutter/material.dart';

enum ThemeEvent { toggle }

class ThemeBloc {
  final _themeController = StreamController<ThemeData>.broadcast();

  Stream<ThemeData> get themeStream => _themeController.stream;

  ThemeData _currentTheme = ThemeData.light();

  void toggleTheme() {
    _currentTheme =
        _currentTheme == ThemeData.light() ? ThemeData.light() : ThemeData.light();
    _themeController.sink.add(_currentTheme);
  }

  void dispose() {
    _themeController.close();
  }
}
