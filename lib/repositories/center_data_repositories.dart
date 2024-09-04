import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/models/center_data_info.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/models/log_data_model.dart';
import 'package:center_monitor/serivices/api_services.dart';

class CenterDataRepostiories {
  final ApiServices apiServices;

  CenterDataRepostiories({required this.apiServices});

  Future<CenterDataInfo> getCenterData(
      {required A10 device, required String loginNumber}) async {
    try {
      List<LogData> logDatas;

      if (loginNumber == '010-9999-9999') {
        logDatas = await apiServices.selectInSungCenterData(device);
      } else if (loginNumber == '010-7777-7777') {
        logDatas = await apiServices.selectMnbCenterData(device);
      } else {
        throw CustomError(errMsg: 'LoginNumber Err');
      }
      CenterDataInfo centerDataInfo = CenterDataInfo(logDatas: logDatas);

      return centerDataInfo;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
