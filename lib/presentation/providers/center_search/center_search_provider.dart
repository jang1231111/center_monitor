import 'package:center_monitor/presentation/providers/center_search/center_search_state.dart';
import 'package:flutter/material.dart';

class CenterSearchProvider with ChangeNotifier {
  CenterSearchState _state = CenterSearchState.initial();
  CenterSearchState get state => _state;

  void setSearchTerm(String newSearchTerm) {
    _state = _state.copyWith(searchTerm: newSearchTerm);
    notifyListeners();
  }
}
