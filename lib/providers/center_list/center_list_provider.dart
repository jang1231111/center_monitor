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

  Future<void> signIn({
    required String ID,
    required String Password,
  }) async {
    _state = _state.copyWith(centerListStatus: CenterListStatus.submitting);
    notifyListeners();

    try {
      final centerListInfo =
          await centerListRepositories.signIn(ID: ID, Password: Password);

      _state = _state.copyWith(
          centerListStatus: CenterListStatus.success,
          centerListInfo: centerListInfo);

      // print(_state.centerListInfo);
      notifyListeners();
    } on CustomError catch (e) {
      _state =
          _state.copyWith(centerListStatus: CenterListStatus.error, error: e);
      notifyListeners();
      rethrow;
    }
  }
}
