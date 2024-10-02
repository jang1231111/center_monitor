import 'package:center_monitor/models/device_list_info.dart';
import 'package:center_monitor/models/custom_error.dart';

enum DeviceListStatus {
  initial,
  submitting,
  success,
  error,
}

class CenterListState {
  final DeviceListStatus centerListStatus;
  final DeviceListInfo centerListInfo;
  final CustomError error;

  factory CenterListState.initial() {
    return CenterListState(
        centerListStatus: DeviceListStatus.initial,
        centerListInfo: DeviceListInfo.initial(),
        error: CustomError());
  }

  CenterListState(
      {required this.centerListStatus,
      required this.centerListInfo,
      required this.error});

  @override
  String toString() =>
      'CenterListState(signinStatus: $centerListStatus, centerListInfo: $centerListInfo, error: $error)';

  CenterListState copyWith({
    DeviceListStatus? centerListStatus,
    DeviceListInfo? centerListInfo,
    CustomError? error,
  }) {
    return CenterListState(
      centerListStatus: centerListStatus ?? this.centerListStatus,
      centerListInfo: centerListInfo ?? this.centerListInfo,
      error: error ?? this.error,
    );
  }
}
