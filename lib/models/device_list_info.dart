import 'package:center_monitor/models/a10_model.dart';

class DeviceListInfo {
  final DateTime updateTime;
  final List<A10> devices;

  factory DeviceListInfo.initial() {
    return DeviceListInfo(devices: [], updateTime: DateTime.now());
  }

  DeviceListInfo({required this.updateTime, required this.devices});

  @override
  String toString() =>
      'CenterListInfo(updateTime: $updateTime, devices: $devices)';

  DeviceListInfo copyWith({
    DateTime? updateTime,
    List<A10>? devices,
  }) {
    return DeviceListInfo(
      updateTime: updateTime ?? this.updateTime,
      devices: devices ?? this.devices,
    );
  }
}
