import 'package:center_monitor/domain/entities/error/custom_error.dart';
import 'package:center_monitor/domain/usecases/version/check_version_update_usecase.dart';
import 'package:center_monitor/presentation/providers/version/version_state.dart';
import 'package:flutter/material.dart';

class VersionProvider extends ChangeNotifier {
  VersionState _state = VersionState.initial();
  VersionState get state => _state;

  final CheckVersionUpdateUseCase getVersionUseCase;

  VersionProvider({required this.getVersionUseCase});

Future<void> checkForUpdate() async {
  try {
      final newDownloadLink = await getVersionUseCase.execute();

      if (newDownloadLink != null) {
        _state = state.copyWith(
          isUpdateRequired: true,
          downloadLink: newDownloadLink,
        );
      } else {
        _state = state.copyWith(
          isUpdateRequired: false,
          downloadLink: null,
        );
      }

      notifyListeners();
    } on CustomError catch (e) {
      debugPrint("CersionProvider checkForUpdate Err : ${e.errMsg}");
    }
  }
}
