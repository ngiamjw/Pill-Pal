import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.dark(
        surface: Colors.grey.shade900,
        primary: Colors.grey.shade600,
        secondary: Colors.grey.shade700,
        tertiary: Colors.grey.shade800,
        onPrimaryContainer: Colors.grey[200],
        onPrimaryFixed: Colors.grey.withOpacity(0.3),
        onSecondaryContainer: Colors.green.shade300,
        onTertiaryContainer: Colors.red.shade300,
        inversePrimary: Colors.grey.shade300));
