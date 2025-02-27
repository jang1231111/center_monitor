import 'package:center_monitor/domain/entities/error/custom_error.dart';
import 'package:center_monitor/domain/entities/device/device_list_info.dart';
import 'package:center_monitor/presentation/providers/device_list/device_list_state.dart';
import 'package:center_monitor/data/repositories/device_list_repositories.dart';
import 'package:flutter/material.dart';

class DeviceListProvider with ChangeNotifier {
  DeviceListState _state = DeviceListState.initial();
  DeviceListState get state => _state;

  DeviceListProvider({
    required this.centerListRepositories,
  });

  final DeviceListRepositories centerListRepositories;

  Future<void> getDeviceList({
    required int id,
    required String company,
    required String token,
  }) async {
    _state = _state.copyWith(deviceListStatus: DeviceListStatus.submitting);
    notifyListeners();

    try {
      final deviceListInfo = await centerListRepositories.getDeviceList(
          id: id, company: company, token: token);

      deviceListSort(deviceListInfo.devices);
      _state = _state.copyWith(
          deviceListStatus: DeviceListStatus.success,
          deviceListInfo: deviceListInfo);

      // print(_state.centerListInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state =
          _state.copyWith(deviceListStatus: DeviceListStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }

  void deviceListSort(List<A10> deviceList) {
    A10 temp;

    for (int i = 0; i < deviceList.length - 1; i++) {
      for (int j = 1; j < deviceList.length - i; j++) {
        if (deviceList[j].centerNm.compareTo(deviceList[j - 1].centerNm) < 0) {
          temp = deviceList[j - 1];
          deviceList[j - 1] = deviceList[j];
          deviceList[j] = temp;
        } else if (deviceList[j]
                .centerNm
                .compareTo(deviceList[j - 1].centerNm) ==
            0) {
          if (deviceList[j].deName != null &&
              deviceList[j - 1].deName != null) {
            if (deviceList[j].deName!.compareTo(deviceList[j - 1].deName!) <
                0) {
              temp = deviceList[j - 1];
              deviceList[j - 1] = deviceList[j];
              deviceList[j] = temp;
            }
          }
        }
      }
    }
  }

  /**
 * [type] = 0, startTime 
 * [type] = 1, endTime
 */
  // void modifyDate({
  //   required A10 device,
  //   required int type,
  //   required DateTime dateTime,
  // }) {
  //   final newDevices = _state.centerListInfo.devices;

  //   /// StartTime
  //   if (type == 0) {
  //     for (int i = 0; i < newDevices.length; i++) {
  //       if (newDevices[i].deNumber == device.deNumber) {
  //         newDevices[i] = newDevices[i].copyWith(startTime: dateTime);
  //         break;
  //       }
  //     }
  //   }

  //   /// EndTime
  //   else if (type == 1) {
  //     for (int i = 0; i < newDevices.length; i++) {
  //       if (newDevices[i].deNumber == device.deNumber) {
  //         newDevices[i] = newDevices[i].copyWith(endTime: dateTime);
  //         break;
  //       }
  //     }
  //   }

  //   DeviceListInfo centerListInfo =
  //       _state.centerListInfo.copyWith(devices: newDevices);

  //   _state = _state.copyWith(centerListInfo: centerListInfo);
  //   notifyListeners();
  // }

  /**
 * [type] = 0, startTime 
 * [type] = 1, endTime
 */
  // void modifyTime({
  //   required A10 device,
  //   required int type,
  //   required TimeOfDay time,
  // }) {
  //   final newDevices = _state.centerListInfo.devices;

  //   /// StartTime
  //   if (type == 0) {
  //     for (int i = 0; i < newDevices.length; i++) {
  //       if (newDevices[i].deNumber == device.deNumber) {
  //         final startTime = newDevices[i].timeStamp;
  //         final newStartTime = DateTime(startTime.year, startTime.month,
  //             startTime.day, time.hour, time.minute);

  //         newDevices[i] = newDevices[i].copyWith(startTime: newStartTime);
  //         break;
  //       }
  //     }
  //   }

  //   /// EndTime
  //   else if (type == 1) {
  //     for (int i = 0; i < newDevices.length; i++) {
  //       if (newDevices[i].deNumber == device.deNumber) {
  //         final endTime = newDevices[i].endTime;
  //         final newEndTime = DateTime(
  //             endTime.year, endTime.month, endTime.day, time.hour, time.minute);

  //         newDevices[i] = newDevices[i].copyWith(startTime: newEndTime);
  //         break;
  //       }
  //     }
  //   }

  //   DeviceListInfo centerListInfo =
  //       _state.centerListInfo.copyWith(devices: newDevices);

  //   _state = _state.copyWith(centerListInfo: centerListInfo);
  //   notifyListeners();
  // }
}
