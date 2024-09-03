import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/models/center_list_info.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/providers/center_list/center_list_state.dart';
import 'package:center_monitor/repositories/center_list_repositories.dart';
import 'package:flutter/material.dart';

class CenterListProvider with ChangeNotifier {
  CenterListState _state = CenterListState.initial();
  CenterListState get state => _state;

  CenterListProvider({
    required this.centerListRepositories,
  });

  final CenterListRepositories centerListRepositories;

  Future<void> getCenterList({
    required String phoneNumber,
  }) async {
    _state = _state.copyWith(centerListStatus: CenterListStatus.submitting);
    notifyListeners();

    try {
      final centerListInfo =
          await centerListRepositories.getCenterList(phoneNumber: phoneNumber);
      _state = _state.copyWith(
          centerListStatus: CenterListStatus.success,
          centerListInfo: centerListInfo);

      print(_state.centerListInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state =
          _state.copyWith(centerListStatus: CenterListStatus.error, error: e);
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

    CenterListInfo centerListInfo =
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

    CenterListInfo centerListInfo =
        _state.centerListInfo.copyWith(devices: newDevices);

    _state = _state.copyWith(centerListInfo: centerListInfo);
    notifyListeners();
  }
}