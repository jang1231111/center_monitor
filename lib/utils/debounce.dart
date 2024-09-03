import 'dart:async';
import 'package:flutter/material.dart';

class Debounce {
  int seconds;

  Debounce({
    this.seconds = 10,
  });

  Timer? _timer;

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(seconds: seconds), action);
  }
}
