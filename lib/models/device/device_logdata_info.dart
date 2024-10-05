class DeviceLogDataInfo {
  final List<LogData> logDatas;

  factory DeviceLogDataInfo.initial() {
    return DeviceLogDataInfo(logDatas: []);
  }

  DeviceLogDataInfo({required this.logDatas});

  DeviceLogDataInfo copyWith({
    List<LogData>? logdatas,
  }) {
    return DeviceLogDataInfo(
      logDatas: logdatas ?? this.logDatas,
    );
  }

  @override
  String toString() => 'CenterDataInfo(logdatas: $logDatas)';
}

class LogData {
  final double temp;
  final double hum;
  final DateTime dateTime;

  LogData({required this.temp, required this.hum, required this.dateTime});

  factory LogData.fromJsonLocal(Map<String, dynamic> json) {
    // print(json);
    return LogData(
      temp: json['temp'],
      hum: json['hum'],
      dateTime: DateTime.parse(json['timestamp']).toLocal(),
    );
  }

  @override
  String toString() => 'LogData(temp: $temp, hum: $hum, dateTime: $dateTime)';
}
