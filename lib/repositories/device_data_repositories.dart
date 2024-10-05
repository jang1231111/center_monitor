import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/models/device/device_logdata_info.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/serivices/api_services.dart';

class DeviceDataRepostiories {
  final ApiServices apiServices;

  DeviceDataRepostiories({required this.apiServices});

  Future<DeviceLogDataInfo> getDeviceLogData(
      {required A10 device,
      required String company,
      required String token}) async {
    try {
      List<LogData> logDatas;
      logDatas = await apiServices.getDeviceLogData(device, company, token);

      DeviceLogDataInfo centerDataInfo = DeviceLogDataInfo(logDatas: logDatas);

      return centerDataInfo;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
