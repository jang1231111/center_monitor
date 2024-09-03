import 'package:center_monitor/models/center_list_info.dart';
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

  factory CenterListState.initial() {
    return CenterListState(
        centerListStatus: CenterListStatus.initial,
        centerListInfo: CenterListInfo.initial(),
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
}
