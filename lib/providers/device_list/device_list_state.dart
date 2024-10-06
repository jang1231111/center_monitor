import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/models/custom_error.dart';

enum DeviceListStatus {
  initial,
  submitting,
  success,
  error,
}

class DeviceListState {
  final DeviceListStatus deviceListStatus;
  final DeviceListInfo deviceListInfo;
  final CustomError error;

  factory DeviceListState.initial() {
    return DeviceListState(
        deviceListStatus: DeviceListStatus.initial,
        deviceListInfo: DeviceListInfo.initial(),
        error: CustomError());
  }

  DeviceListState(
      {required this.deviceListStatus,
      required this.deviceListInfo,
      required this.error});

  @override
  String toString() =>
      'CenterListState(signinStatus: $deviceListStatus, centerListInfo: $deviceListInfo, error: $error)';

  DeviceListState copyWith({
    DeviceListStatus? deviceListStatus,
    DeviceListInfo? deviceListInfo,
    CustomError? error,
  }) {
    return DeviceListState(
      deviceListStatus: deviceListStatus ?? this.deviceListStatus,
      deviceListInfo: deviceListInfo ?? this.deviceListInfo,
      error: error ?? this.error,
    );
  }
}
