import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
        surface: Colors.grey.shade100,
        primary: Colors.grey.shade400,
        secondary: Colors.grey.shade500,
        tertiary: Colors.grey[200],
        onPrimaryContainer: Colors.grey[200],
        onPrimaryFixed: Colors.grey.withOpacity(0.3),
        onSecondaryContainer: Colors.green.shade300,
        onTertiaryContainer: Colors.red.shade300,
        inversePrimary: Colors.grey.shade900));
