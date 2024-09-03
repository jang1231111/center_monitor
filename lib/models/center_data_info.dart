import 'package:center_monitor/models/log_data_model.dart';

class CenterDataInfo {
  final List<LogData> logDatas;

  factory CenterDataInfo.initial() {
    return CenterDataInfo(logDatas: []);
  }

  CenterDataInfo({required this.logDatas});

  CenterDataInfo copyWith({
    List<LogData>? logdatas,
  }) {
    return CenterDataInfo(
      logDatas: logdatas ?? this.logDatas,
    );
  }

  @override
  String toString() => 'CenterDataInfo(logdatas: $logDatas)';
}
