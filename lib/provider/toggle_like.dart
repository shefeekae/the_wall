import 'package:flutter/material.dart';

class ToggleLike extends ChangeNotifier {
  bool isLiked = false;

  toggleLike() {
    isLiked = !isLiked;
    notifyListeners();
  }
}
