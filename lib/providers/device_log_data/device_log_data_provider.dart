import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/providers/device_log_data/device_log_data_state.dart';
import 'package:center_monitor/repositories/device_data_repositories.dart';
import 'package:flutter/material.dart';

class DeviceLogDataProvider with ChangeNotifier { 
  DeviceLogDataState _state = DeviceLogDataState.initial();
  DeviceLogDataState get state => _state;

  DeviceLogDataProvider({
    required this.centerDataRepositories,
  });

  final DeviceDataRepostiories centerDataRepositories;

  Future<void> getDeviceLogData({
    required A10 device,
    required String token,
    required String company,
  }) async {
    _state = _state.copyWith(status: DeviceLogDataStatus.submitting);
    notifyListeners();

    try {
      final centerDataInfo = await centerDataRepositories.getDeviceLogData(
          device: device, token: token, company: company);
      // print('${centerDataInfo}');
      _state = _state.copyWith(
          status: DeviceLogDataStatus.success, centerDataInfo: centerDataInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(status: DeviceLogDataStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
