import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  appBarTheme: appBarTheme,
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: Colors.green,
    secondary: Colors.green
  ),
  textTheme: GoogleFonts.latoTextTheme(),
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
  textTheme: GoogleFonts.latoTextTheme(),
  colorScheme: const ColorScheme.dark(
    primary: Colors.green,
    secondary: Colors.green
  )
);

const appBarTheme = AppBarTheme(
  centerTitle: true,
);
