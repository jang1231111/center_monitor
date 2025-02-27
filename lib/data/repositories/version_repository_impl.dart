import 'package:center_monitor/data/datasources/remote/remote_data_source.dart';
import 'package:center_monitor/domain/entities/version/version.dart';

class VersionRepositoryImpl 
// extends VersionRepostirory
{
  final RemoteDataSource _remoteDataSource;

  VersionRepositoryImpl(this._remoteDataSource);

  Future<Version> getVersion() async {
    final versionModel = await _remoteDataSource.fetchVersion();
    return Version(
        latestVersion: versionModel.latestVersion,
        androidDownloadLink: versionModel.androidDownloadLink,
        iosDownloadLink: versionModel.iosDownloadLink,
        updateDate: versionModel.updateDate);
  }
}
