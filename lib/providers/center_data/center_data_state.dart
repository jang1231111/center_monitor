import 'package:center_monitor/models/center_data_info.dart';
import 'package:center_monitor/models/custom_error.dart';

enum CenterDataStatus {
  initial,
  submitting,
  success,
  error,
}

class CenterDataState {
  final CenterDataStatus centerDataStatus;
  final CenterDataInfo centerDataInfo;
  final CustomError error;

  factory CenterDataState.initial() {
    return CenterDataState(
        centerDataStatus: CenterDataStatus.initial,
        centerDataInfo: CenterDataInfo.initial(),
        error: CustomError());
  }

  CenterDataState(
      {required this.centerDataStatus,
      required this.centerDataInfo,
      required this.error});

  CenterDataState copyWith({
    CenterDataStatus? status,
    CenterDataInfo? centerDataInfo,
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
