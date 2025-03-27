import 'package:flutter/material.dart';

class CounterModel with ChangeNotifier {
  int x = 0;
  List<Color> containerColors = [];
  String selected_user = '';
}
