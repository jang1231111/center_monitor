import 'package:center_monitor/domain/entities/center/center_list_info.dart';

class CenterInfoState {
  String token;
  CenterInfo center;

  CenterInfoState({
    required this.token,
    required this.center, 
  });

  CenterInfoState copyWith({
    String? token,
    CenterInfo? center,
  }) {
    return CenterInfoState(
      token: token ?? this.token,
      center: center ?? this.center,
    );
  }

  @override
  String toString() => 'CenterInfoState(token: $token, center: $center)';
}
