import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/providers/device_list/device_list_state.dart';
import 'package:center_monitor/repositories/device_list_repositories.dart';
import 'package:flutter/material.dart';

class DeviceListProvider with ChangeNotifier {
  DeviceListState _state = DeviceListState.initial();
  DeviceListState get state => _state;

  DeviceListProvider({
    required this.centerListRepositories,
  });

  final DeviceListRepositories centerListRepositories;

  // Future<void> signIn({
  //   required String ID,
  //   required String Password,
  // }) async {
  //   _state = _state.copyWith(centerListStatus: DeviceListStatus.submitting);
  //   notifyListeners();

  //   try {
  //     final centerListInfo =
  //         await centerListRepositories.signIn(ID: ID, Password: Password);
  //     _state = _state.copyWith(
  //         centerListStatus: DeviceListStatus.success,
  //         centerListInfo: centerListInfo);

  //     print(_state.centerListInfo);
  //     notifyListeners();
  //   } on CustomError catch (e) {
  //     _state =
  //         _state.copyWith(centerListStatus: DeviceListStatus.error, error: e);
  //     notifyListeners();
  //     rethrow;
  //   }
  // }

  Future<void> getDeviceList({
    required int centerSn,
  }) async {
    _state = _state.copyWith(centerListStatus: DeviceListStatus.submitting);
    notifyListeners();

    try {
      final centerListInfo =
          await centerListRepositories.getDeviceList(phoneNumber: phoneNumber);
      _state = _state.copyWith(
          centerListStatus: DeviceListStatus.success,
          centerListInfo: centerListInfo);

      print(_state.centerListInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state =
          _state.copyWith(centerListStatus: DeviceListStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }

  /**
 * [type] = 0, startTime 
 * [type] = 1, endTime
 */
  void modifyDate({
    required A10 device,
    required int type,
    required DateTime dateTime,
  }) {
    final newDevices = _state.centerListInfo.devices;

    /// StartTime
    if (type == 0) {
      for (int i = 0; i < newDevices.length; i++) {
        if (newDevices[i].deNumber == device.deNumber) {
          newDevices[i] = newDevices[i].copyWith(startTime: dateTime);
          break;
        }
      }
    }

    /// EndTime
    else if (type == 1) {
      for (int i = 0; i < newDevices.length; i++) {
        if (newDevices[i].deNumber == device.deNumber) {
          newDevices[i] = newDevices[i].copyWith(endTime: dateTime);
          break;
        }
      }
    }

    DeviceListInfo centerListInfo =
        _state.centerListInfo.copyWith(devices: newDevices);

    _state = _state.copyWith(centerListInfo: centerListInfo);
    notifyListeners();
  }

  /**
 * [type] = 0, startTime 
 * [type] = 1, endTime
 */
  void modifyTime({
    required A10 device,
    required int type,
    required TimeOfDay time,
  }) {
    final newDevices = _state.centerListInfo.devices;

    /// StartTime
    if (type == 0) {
      for (int i = 0; i < newDevices.length; i++) {
        if (newDevices[i].deNumber == device.deNumber) {
          final startTime = newDevices[i].startTime;
          final newStartTime = DateTime(startTime.year, startTime.month,
              startTime.day, time.hour, time.minute);

          newDevices[i] = newDevices[i].copyWith(startTime: newStartTime);
          break;
        }
      }
    }

    /// EndTime
    else if (type == 1) {
      for (int i = 0; i < newDevices.length; i++) {
        if (newDevices[i].deNumber == device.deNumber) {
          final endTime = newDevices[i].endTime;
          final newEndTime = DateTime(
              endTime.year, endTime.month, endTime.day, time.hour, time.minute);

          newDevices[i] = newDevices[i].copyWith(startTime: newEndTime);
          break;
        }
      }
    }

    DeviceListInfo centerListInfo =
        _state.centerListInfo.copyWith(devices: newDevices);

    _state = _state.copyWith(centerListInfo: centerListInfo);
    notifyListeners();
  }
}
