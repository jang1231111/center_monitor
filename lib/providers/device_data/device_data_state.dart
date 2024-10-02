import 'package:center_monitor/models/device_data_info.dart';
import 'package:center_monitor/models/custom_error.dart';

enum DeviceDataStatus {
  initial,
  submitting,
  success,
  error,
}

class CenterDataState {
  final DeviceDataStatus centerDataStatus;
  final DeviceDataInfo centerDataInfo;
  final CustomError error;

  factory CenterDataState.initial() {
    return CenterDataState(
        centerDataStatus: DeviceDataStatus.initial,
        centerDataInfo: DeviceDataInfo.initial(),
        error: CustomError());
  }

  CenterDataState(
      {required this.centerDataStatus,
      required this.centerDataInfo,
      required this.error});

  CenterDataState copyWith({
    DeviceDataStatus? status,
    DeviceDataInfo? centerDataInfo,
    CustomError? error,
  }) {
    return CenterDataState(
      centerDataStatus: status ?? this.centerDataStatus,
      centerDataInfo: centerDataInfo ?? this.centerDataInfo,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'CenterDataState(status: $centerDataStatus, centerDataInfo: $centerDataInfo, error: $error)';
}
