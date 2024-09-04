import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/models/center_list_info.dart';
import 'package:center_monitor/serivices/api_services.dart';

class CenterListRepositories {
  final ApiServices apiServices;

  CenterListRepositories({required this.apiServices});

  Future<CenterListInfo> getCenterList({required String phoneNumber}) async {
    try {
      List<A10> deviceList = await apiServices.selectInSungCenterList();
      if (phoneNumber == '010-9999-9999') {
        deviceList = await apiServices.selectInSungCenterList();
      } else if (phoneNumber == '010-7777-7777') {
        deviceList = await apiServices.selectMnbCenterList();
      } else {
        throw CustomError(errMsg: '전화번호를 확인해주세요.');
      }

      final DateTime currentTime = DateTime.now();

      CenterListInfo centerListInfo =
          CenterListInfo(devices: deviceList, updateTime: currentTime);

      // print(centerListInfo);

      return centerListInfo;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
