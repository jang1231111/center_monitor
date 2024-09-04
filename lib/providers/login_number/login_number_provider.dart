import 'package:center_monitor/providers/login_number/login_number_state.dart';
import 'package:flutter/material.dart';

class LoginNumberProvider extends ChangeNotifier {
  LoginNumberState _state = LoginNumberState.intitial();
  LoginNumberState get state => _state;

  changeLoginNumber(String newLoginNumber) {
    _state = _state.copyWith(phontNumber: newLoginNumber);
    notifyListeners();
  }
}
