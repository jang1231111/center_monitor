import 'package:center_monitor/domain/entities/filter/device_filter.dart';
import 'package:center_monitor/presentation/providers/device_filter/device_filter_state.dart';
import 'package:flutter/material.dart';

class DeviceFilterProvider with ChangeNotifier {
  DeviceFilterState _state = DeviceFilterState.initial();
  DeviceFilterState get state => _state;

  void changeFilter(Filter newFilter) {
    _state = _state.copyWith(filter: newFilter);
    notifyListeners();
  }
}
