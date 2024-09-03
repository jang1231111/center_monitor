import 'package:center_monitor/models/log_data_model.dart';
import 'package:center_monitor/providers/center_data/center_data_provider.dart';
import 'package:center_monitor/providers/center_report/center_report_state.dart';

class CenterReportProvider {
  final CenterDataProvider centerDataProvider;

  CenterReportProvider({required this.centerDataProvider});

  CenterReportState get state {
    List<LogData> logDatas = centerDataProvider.state.centerDataInfo.logDatas;
    double _tempLow = 999;
    double _tempHigh = -999;
    double _humLow = 999;
    double _humHigh = -999;

    if (logDatas.isNotEmpty) {
      for (int i = 1; i < logDatas.length; i++) {
        if (_tempLow > double.parse(logDatas[i].temp)) {
          _tempLow = double.parse(logDatas[i].temp);
        }
        if (_tempHigh < double.parse(logDatas[i].temp)) {
          _tempHigh = double.parse(logDatas[i].temp);
        }
        if (_humLow > double.parse(logDatas[i].hum)) {
          _humLow = double.parse(logDatas[i].hum);
        }
        if (_humHigh < double.parse(logDatas[i].hum)) {
          _humHigh = double.parse(logDatas[i].hum);
        }
      }
    }
    return CenterReportState(
        tempLow: _tempLow,
        tempHigh: _tempHigh,
        humLow: _humLow,
        humHigh: _humHigh);
  }
}
