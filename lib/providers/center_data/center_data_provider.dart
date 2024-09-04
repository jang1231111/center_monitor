import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/providers/center_data/center_data_state.dart';
import 'package:center_monitor/repositories/center_data_repositories.dart';
import 'package:flutter/material.dart';

class CenterDataProvider with ChangeNotifier {
  CenterDataState _state = CenterDataState.initial();
  CenterDataState get state => _state;

  CenterDataProvider({
    required this.centerDataRepositories,
  });

  final CenterDataRepostiories centerDataRepositories;

  Future<void> getCenterData({
    required A10 device,
    required String loginNumber,
  }) async {
    _state = _state.copyWith(status: CenterDataStatus.submitting);
    notifyListeners();

    try {
      final centerDataInfo = await centerDataRepositories.getCenterData(
          device: device, loginNumber: loginNumber);
      print('${centerDataInfo}');
      _state = _state.copyWith(
          status: CenterDataStatus.success, centerDataInfo: centerDataInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(status: CenterDataStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
