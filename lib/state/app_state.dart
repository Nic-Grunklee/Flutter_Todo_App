
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier {
  int _bottomIndex = 0;

  AppState._();

  factory AppState() {
    return AppState._();
  }

  int get bottomIndex => _bottomIndex;

  void changeBottomIndex(int index) {
    _bottomIndex = index;
    notifyListeners();
  }
}