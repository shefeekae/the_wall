import 'package:flutter/material.dart';

class TextFieldProvider extends ChangeNotifier {
  clearTextField(TextEditingController controller) {
    controller.clear();
    notifyListeners();
  }
}
