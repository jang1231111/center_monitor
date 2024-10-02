import 'package:center_monitor/models/center/center_info.dart';
import 'package:center_monitor/models/center/center_list_info.dart';
import 'package:center_monitor/models/custom_error.dart';

enum CenterListStatus {
  initial,
  submitting,
  success,
  error,
}

class CenterListState {
  final CenterListStatus centerListStatus;
  final CenterListInfo centerListInfo;
  final CenterInfo centerInfo;
  final CustomError error;

  CenterListState(
      {required this.centerListStatus,
      required this.centerListInfo,
      required this.centerInfo,
      required this.error});

  factory CenterListState.initial() {
    return CenterListState(
        centerInfo: CenterInfo.initial(),
        centerListStatus: CenterListStatus.initial,
        centerListInfo: CenterListInfo.initial(),
        error: CustomError());
  }

  CenterListState copyWith({
    CenterListStatus? centerListStatus,
    CenterListInfo? centerListInfo,
    CenterInfo? centerInfo,
    CustomError? error,
  }) {
    return CenterListState(
      centerListStatus: centerListStatus ?? this.centerListStatus,
      centerListInfo: centerListInfo ?? this.centerListInfo,
      centerInfo: centerInfo ?? this.centerInfo,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'CenterListState(centerListStatus: $centerListStatus, centerListInfo: $centerListInfo, centerInfo: $centerInfo, error: $error)';
  }
}
