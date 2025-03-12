import 'package:flutter/material.dart';

void displayErrorMessage(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(message, textAlign: TextAlign.center),
          ));
}
