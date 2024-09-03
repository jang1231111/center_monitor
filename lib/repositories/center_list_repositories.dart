import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/models/center_list_info.dart';
import 'package:center_monitor/serivices/api_services.dart';

class CenterListRepositories {
  final ApiServices apiServices;

  CenterListRepositories({required this.apiServices});

  Future<CenterListInfo> getCenterList({required String phoneNumber}) async {
    try {
      final List<A10> deviceList = await apiServices.selectCenterList();
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
