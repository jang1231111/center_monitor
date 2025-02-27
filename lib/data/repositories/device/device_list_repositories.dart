import 'package:center_monitor/domain/entities/error/custom_error.dart';
import 'package:center_monitor/domain/entities/device/device_list_info.dart';
import 'package:center_monitor/data/datasources/remote/api_services.dart';

class DeviceListRepositories {
  final ApiServices apiServices;

  DeviceListRepositories({required this.apiServices});

  Future<DeviceListInfo> getDeviceList({
    required int id,
    required String company,
    required String token,
  }) async {
    try {
      List<A10> deviceList;
      deviceList = await apiServices.getDeviceList(id, company, token);

      final DateTime currentTime = DateTime.now();

      DeviceListInfo centerListInfo =
          DeviceListInfo(devices: deviceList, updateTime: currentTime);

      // print(centerListInfo);

      return centerListInfo;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
