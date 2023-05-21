import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  appBarTheme: appBarTheme,
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: Colors.green,
    secondary: Colors.green
  ),
  dividerTheme: const DividerThemeData(
    thickness: 0.5,
  )
);

final darkTheme = ThemeData.dark().copyWith(
  appBarTheme: appBarTheme,
  useMaterial3: true,
  dividerTheme: const DividerThemeData(
    thickness: 0.5,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Colors.green,
    secondary: Colors.green
  )
);

const appBarTheme = AppBarTheme(
  centerTitle: true,
);
