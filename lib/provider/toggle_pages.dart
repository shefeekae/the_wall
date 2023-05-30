import 'package:flutter/material.dart';

class TogglePages extends ChangeNotifier {
  bool showLogin = true;

  togglePages() {
    showLogin = !showLogin;
    notifyListeners();
  }
}
