import 'package:center_monitor/models/center/center_list_info.dart';
import 'package:center_monitor/models/center/selected_center_info.dart';
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
  final SelectedCenterInfo selectedCenterInfo;
  final CustomError error;

  CenterListState(
      {required this.centerListStatus,
      required this.centerListInfo,
      required this.selectedCenterInfo,
      required this.error});

  factory CenterListState.initial() {
    return CenterListState(
        centerListStatus: CenterListStatus.initial,
        centerListInfo: CenterListInfo.initial(),
        selectedCenterInfo: SelectedCenterInfo.initial(),
        error: CustomError());
  }

  CenterListState copyWith({
    CenterListStatus? centerListStatus,
    CenterListInfo? centerListInfo,
    SelectedCenterInfo? selectedCenterInfo,
    CustomError? error,
  }) {
    return CenterListState(
      centerListStatus: centerListStatus ?? this.centerListStatus,
      centerListInfo: centerListInfo ?? this.centerListInfo,
      selectedCenterInfo: selectedCenterInfo ?? this.selectedCenterInfo,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'CenterListState(centerListStatus: $centerListStatus, centerListInfo: $centerListInfo, selectedCenterInfo: $selectedCenterInfo, error: $error)';
  }
}
