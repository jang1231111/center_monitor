import 'dart:io';
import 'package:center_monitor/domain/entities/version/version.dart';
import 'package:center_monitor/domain/repositories/version_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CheckVersionUpdateUseCase {
  final VersionRepository _repository;

  CheckVersionUpdateUseCase(this._repository);

  Future<String?> execute() async {
    final latestVersion = await _repository.getVersion();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    if (_isUpdateRequired(currentVersion, latestVersion.latestVersion)) {
      return _getDownloadLink(latestVersion);
    }

    return null; // 최신 버전과 동일하면 업데이트 필요 없음
  }

  bool _isUpdateRequired(String currentVersion, String latestVersion) {
    return currentVersion != latestVersion;
  }

  String _getDownloadLink(Version latestVersion) {
    return Platform.isIOS
        ? latestVersion.iosDownloadLink
        : latestVersion.androidDownloadLink;
  }
}
