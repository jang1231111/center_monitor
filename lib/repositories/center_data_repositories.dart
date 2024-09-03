import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/models/center_data_info.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/models/log_data_model.dart';
import 'package:center_monitor/serivices/api_services.dart';

class CenterDataRepostiories {
  final ApiServices apiServices;

  CenterDataRepostiories({required this.apiServices});

  Future<CenterDataInfo> getCenterData({required A10 device}) async {
    try {
      final List<LogData> logDatas = await apiServices.selectCenterData(device);

      CenterDataInfo centerDataInfo = CenterDataInfo(logDatas: logDatas);

      return centerDataInfo;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
