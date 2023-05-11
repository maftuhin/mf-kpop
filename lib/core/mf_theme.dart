import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  appBarTheme: appBarTheme,
  useMaterial3: true,
  colorSchemeSeed: Colors.green
);

final darkTheme = ThemeData.dark().copyWith(
  appBarTheme: appBarTheme,
  useMaterial3: true,
);

const appBarTheme = AppBarTheme(
  // elevation: 0.0,
  centerTitle: true,
);
