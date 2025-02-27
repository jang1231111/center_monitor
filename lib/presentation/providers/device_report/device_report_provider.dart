import 'package:center_monitor/domain/entities/device/device_logdata_info.dart';
import 'package:center_monitor/presentation/providers/device_log_data/device_log_data_provider.dart';
import 'package:center_monitor/presentation/providers/device_report/device_report_state.dart';

class DeviceReportProvider {
  final DeviceLogDataProvider centerDataProvider;

  DeviceReportProvider({required this.centerDataProvider});

  DeviceReportState get state {
    List<LogData> logDatas =
        centerDataProvider.state.deviceLogDataInfo.logDatas;
    double _tempLow = 999;
    double _tempHigh = -999;
    double _humLow = 999;
    double _humHigh = -999;

    if (logDatas.isNotEmpty) {
      for (int i = 1; i < logDatas.length; i++) {
        if (_tempLow > logDatas[i].temp) {
          _tempLow = logDatas[i].temp;
        }
        if (_tempHigh < logDatas[i].temp) {
          _tempHigh = logDatas[i].temp;
        }
        if (_humLow > logDatas[i].hum) {
          _humLow = logDatas[i].hum;
        }
        if (_humHigh < logDatas[i].hum) {
          _humHigh = logDatas[i].hum;
        }
      }
    }
    return DeviceReportState(
        tempLow: _tempLow,
        tempHigh: _tempHigh,
        humLow: _humLow,
        humHigh: _humHigh);
  }
}
