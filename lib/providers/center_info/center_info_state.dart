import 'package:center_monitor/models/center/center_list_info.dart'
    as centerInfo;

class CenterInfoState {
  String token;
  centerInfo.CenterInfo center;

  CenterInfoState({
    required this.token,
    required this.center,
  });

  CenterInfoState copyWith({
    String? token,
    centerInfo.CenterInfo? center,
  }) {
    return CenterInfoState(
      token: token ?? this.token,
      center: center ?? this.center,
    );
  }

  @override
  String toString() => 'CenterInfoState(token: $token, center: $center)';
}