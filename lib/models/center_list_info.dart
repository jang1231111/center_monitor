import 'package:center_monitor/models/a10_model.dart';

class CenterListInfo {
  final DateTime updateTime;
  final List<A10> devices;

  factory CenterListInfo.initial() {
    return CenterListInfo(devices: [], updateTime: DateTime.now());
  }

  CenterListInfo({required this.updateTime, required this.devices});

  @override
  String toString() =>
      'CenterListInfo(updateTime: $updateTime, devices: $devices)';

  CenterListInfo copyWith({
    DateTime? updateTime,
    List<A10>? devices,
  }) {
    return CenterListInfo(
      updateTime: updateTime ?? this.updateTime,
      devices: devices ?? this.devices,
    );
  }
}
