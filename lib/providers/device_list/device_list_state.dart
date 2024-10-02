import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/models/custom_error.dart';

enum DeviceListStatus {
  initial,
  submitting,
  success,
  error,
}

class DeviceListState {
  final DeviceListStatus centerListStatus;
  final DeviceListInfo centerListInfo;
  final CustomError error;

  factory DeviceListState.initial() {
    return DeviceListState(
        centerListStatus: DeviceListStatus.initial,
        centerListInfo: DeviceListInfo.initial(),
        error: CustomError());
  }

  DeviceListState(
      {required this.centerListStatus,
      required this.centerListInfo,
      required this.error});

  @override
  String toString() =>
      'CenterListState(signinStatus: $centerListStatus, centerListInfo: $centerListInfo, error: $error)';

  DeviceListState copyWith({
    DeviceListStatus? centerListStatus,
    DeviceListInfo? centerListInfo,
    CustomError? error,
  }) {
    return DeviceListState(
      centerListStatus: centerListStatus ?? this.centerListStatus,
      centerListInfo: centerListInfo ?? this.centerListInfo,
      error: error ?? this.error,
    );
  }
}
