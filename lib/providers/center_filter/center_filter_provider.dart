import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/providers/center_filter/center_filter_state.dart';
import 'package:flutter/material.dart';

class CenterFilterProvider with ChangeNotifier {
  CenterFilterState _state = CenterFilterState.initial();
  CenterFilterState get state => _state;

  void changeFilter(Filter newFilter) {
    _state = _state.copyWith(filter: newFilter);
    notifyListeners();
  }
}
