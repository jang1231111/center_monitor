import 'package:center_monitor/domain/entities/center/center_list_info.dart';

class LoginInfo {
  final String company;
  final String token; 
  final CenterInfo selectedCenter;

  LoginInfo(
      {required this.company,
      required this.token,
      required this.selectedCenter});

  factory LoginInfo.initial() {
    return LoginInfo(company: '', token: '', selectedCenter: CenterInfo.initial());
  }

  LoginInfo copyWith({
    String? company,
    String? token,
    CenterInfo? selectedCenter,
  }) {
    return LoginInfo(
      company: company ?? this.company,
      token: token ?? this.token,
      selectedCenter: selectedCenter ?? this.selectedCenter,
    );
  }

  @override
  String toString() =>
      'SelectedCenterInfo(company: $company, token: $token, selectedCenter: $selectedCenter)';
}
