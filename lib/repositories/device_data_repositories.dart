import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/models/device/device_logdata_info.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/serivices/api_services.dart';

class DeviceDataRepostiories {
  final ApiServices apiServices;

  DeviceDataRepostiories({required this.apiServices});

  // Future<DeviceLogDataInfo> getCenterData(
  //     {required A10 device, required String loginNumber}) async {
  //   try {
  //     List<LogData> logDatas;

  //     if (loginNumber == '010-9999-9999') {
  //       logDatas = await apiServices.selectInSungCenterData(device);
  //     } else if (loginNumber == '010-7777-7777') {
  //       logDatas = await apiServices.selectMnbCenterData(device);
  //     } else {
  //       throw CustomError(errMsg: 'LoginNumber Err');
  //     }
  //     DeviceLogDataInfo centerDataInfo = DeviceLogDataInfo(logDatas: logDatas);

  //     return centerDataInfo;
  //   } catch (e) {
  //     throw CustomError(errMsg: e.toString());
  //   }
  // }
}
