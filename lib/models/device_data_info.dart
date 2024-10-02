import 'package:center_monitor/models/log_data_model.dart';

class DeviceDataInfo {
  final List<LogData> logDatas;

  factory DeviceDataInfo.initial() {
    return DeviceDataInfo(logDatas: []);
  }

  DeviceDataInfo({required this.logDatas});

  DeviceDataInfo copyWith({
    List<LogData>? logdatas,
  }) {
    return DeviceDataInfo(
      logDatas: logdatas ?? this.logDatas,
    );
  }

  @override
  String toString() => 'CenterDataInfo(logdatas: $logDatas)';
}
