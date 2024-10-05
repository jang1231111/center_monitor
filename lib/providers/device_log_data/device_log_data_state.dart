import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/models/device/device_logdata_info.dart';

enum DeviceLogDataStatus {
  initial,
  submitting,
  success,
  error,
}

class DeviceLogDataState {
  final DeviceLogDataStatus deviceLogDataStatus;
  final DeviceLogDataInfo deviceLogDataInfo;
  final CustomError error;

  factory DeviceLogDataState.initial() {
    return DeviceLogDataState(
        deviceLogDataStatus: DeviceLogDataStatus.initial,
        deviceLogDataInfo: DeviceLogDataInfo.initial(),
        error: CustomError());
  }

  DeviceLogDataState(
      {required this.deviceLogDataStatus,
      required this.deviceLogDataInfo,
      required this.error});

  DeviceLogDataState copyWith({
    DeviceLogDataStatus? status,
    DeviceLogDataInfo? centerDataInfo,
    CustomError? error,
  }) {
    return DeviceLogDataState(
      deviceLogDataStatus: status ?? this.deviceLogDataStatus,
      deviceLogDataInfo: centerDataInfo ?? this.deviceLogDataInfo,
      error: error ?? this.error,
    );
  }

  @override

  @override
  String toString() => 'DeviceLogDataState(centerDataStatus: $deviceLogDataStatus, centerDataInfo: $deviceLogDataInfo, error: $error)';
}
