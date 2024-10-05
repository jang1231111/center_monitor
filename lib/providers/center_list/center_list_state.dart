import 'package:center_monitor/models/center/center_list_info.dart';
import 'package:center_monitor/models/center/login_info.dart';
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
  final LoginInfo loginInfo;
  final CustomError error;

  CenterListState(
      {required this.centerListStatus,
      required this.centerListInfo,
      required this.loginInfo,
      required this.error});

  factory CenterListState.initial() {
    return CenterListState(
        centerListStatus: CenterListStatus.initial,
        centerListInfo: CenterListInfo.initial(),
        loginInfo: LoginInfo.initial(),
        error: CustomError());
  }

  CenterListState copyWith({
    CenterListStatus? centerListStatus,
    CenterListInfo? centerListInfo,
    LoginInfo? loginInfo,
    CustomError? error,
  }) {
    return CenterListState(
      centerListStatus: centerListStatus ?? this.centerListStatus,
      centerListInfo: centerListInfo ?? this.centerListInfo,
      loginInfo: loginInfo ?? this.loginInfo,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'CenterListState(centerListStatus: $centerListStatus, centerListInfo: $centerListInfo, loginInfo: $loginInfo, error: $error)';
  }
}
