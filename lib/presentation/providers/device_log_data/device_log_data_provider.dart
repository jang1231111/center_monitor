import 'package:center_monitor/domain/entities/error/custom_error.dart';
import 'package:center_monitor/domain/entities/device/device_list_info.dart';
import 'package:center_monitor/presentation/providers/device_log_data/device_log_data_state.dart';
import 'package:center_monitor/data/repositories/device/device_data_repositories.dart';
import 'package:flutter/material.dart';

class DeviceLogDataProvider with ChangeNotifier {
  DeviceLogDataState _state = DeviceLogDataState.initial();
  DeviceLogDataState get state => _state;

  final DeviceDataRepostiories centerDataRepositories;
  
  DeviceLogDataProvider({
    required this.centerDataRepositories,
  });

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
