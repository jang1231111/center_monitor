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
  final CustomError error;

  CenterListState(
      {required this.centerListStatus,
      required this.centerListInfo,
      required this.error});

  factory CenterListState.initial() {
    return CenterListState(
        centerListStatus: CenterListStatus.initial,
        centerListInfo: CenterListInfo.initial(),
        error: CustomError());
  }

  CenterListState copyWith({
    CenterListStatus? centerListStatus,
    CenterListInfo? centerListInfo,
    CustomError? error,
  }) {
    return CenterListState(
      centerListStatus: centerListStatus ?? this.centerListStatus,
      centerListInfo: centerListInfo ?? this.centerListInfo,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'CenterListState(centerListStatus: $centerListStatus, centerListInfo: $centerListInfo, error: $error)';
}
