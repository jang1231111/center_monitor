import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/providers/device_data/device_data_state.dart';
import 'package:center_monitor/repositories/center_data_repositories.dart';
import 'package:flutter/material.dart';

class DeviceDataProvider with ChangeNotifier {
  CenterDataState _state = CenterDataState.initial();
  CenterDataState get state => _state;

  DeviceDataProvider({
    required this.centerDataRepositories,
  });

  final CenterDataRepostiories centerDataRepositories;

  Future<void> getCenterData({
    required A10 device,
    required String loginNumber,
  }) async {
    _state = _state.copyWith(status: DeviceDataStatus.submitting);
    notifyListeners();

    try {
      final centerDataInfo = await centerDataRepositories.getCenterData(
          device: device, loginNumber: loginNumber);
      print('${centerDataInfo}');
      _state = _state.copyWith(
          status: DeviceDataStatus.success, centerDataInfo: centerDataInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(status: DeviceDataStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
