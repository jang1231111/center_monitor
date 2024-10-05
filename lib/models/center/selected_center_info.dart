import 'package:center_monitor/models/center/center_list_info.dart';

class SelectedCenterInfo {
  final String company;
  final String token;
  final CenterInfo selectedConter;

  SelectedCenterInfo(
      {required this.company,
      required this.token,
      required this.selectedConter});

  factory SelectedCenterInfo.initial() {
    return SelectedCenterInfo(company: '', token: '', selectedConter: CenterInfo.initial());
  }

  SelectedCenterInfo copyWith({
    String? company,
    String? token,
    CenterInfo? selectedConter,
  }) {
    return SelectedCenterInfo(
      company: company ?? this.company,
      token: token ?? this.token,
      selectedConter: selectedConter ?? this.selectedConter,
    );
  }

  @override
  String toString() =>
      'SelectedCenterInfo(company: $company, token: $token, selectedConter: $selectedConter)';
}
