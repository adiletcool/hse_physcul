import 'package:flutter/material.dart';
import 'package:hse_phsycul/HexColor.dart';
import 'package:theme_provider/theme_provider.dart';

List<AppTheme> myThemes = [
  AppTheme.light().copyWith(
    id: 'light',
    data: ThemeData.light().copyWith(
      backgroundColor: HexColor.fromHex('#efecec'),
      appBarTheme: AppBarTheme(color: HexColor.fromHex('#2d767f')),
    ),
  ),
  AppTheme.dark().copyWith(
      id: 'dark',
      data: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(color: Colors.black54),
      )),
];
