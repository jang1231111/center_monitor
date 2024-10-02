import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/serivices/api_services.dart';

class DeviceListRepositories {
  final ApiServices apiServices;

  DeviceListRepositories({required this.apiServices});

  Future<DeviceListInfo> getCenterList({required String phoneNumber}) async {
    try {
      List<A10> deviceList;
      if (phoneNumber == '010-9999-9999') {
        deviceList = await apiServices.selectInSungCenterList();
      } else if (phoneNumber == '010-8888-8888') {
        deviceList = await apiServices.selectBrCenterList();
      } else if (phoneNumber == '010-7777-7777') {
        deviceList = await apiServices.selectMnbCenterList();
      } else if (phoneNumber == '010-6666-6666') {
        deviceList = await apiServices.selectBcsCenterList();
      } else {
        throw CustomError(errMsg: '전화번호를 확인해주세요.');
      }

      final DateTime currentTime = DateTime.now();

      DeviceListInfo centerListInfo =
          DeviceListInfo(devices: deviceList, updateTime: currentTime);

      print(centerListInfo);

      return centerListInfo;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
