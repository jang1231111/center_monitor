import 'package:center_monitor/domain/entities/version/version.dart';

class VersionModel extends Version {
  VersionModel(
      {required super.latestVersion,
      required super.androidDownloadLink,
      required super.iosDownloadLink,
      required super.updateDate});

  factory VersionModel.fromMap(Map<String, dynamic> map) {
    return VersionModel(
      latestVersion: map['latestVersion'] as String,
      androidDownloadLink: map['androidDownloadLink'] as String,
      iosDownloadLink: map['iosDownloadLink'] as String,
      updateDate: DateTime.parse(map['updateDate'] as String),
    );
  }

  Map<String, dynamic> tojson() {
    return {
      "latestVersion": latestVersion,
      "androidDownloadLink": androidDownloadLink,
      "iosDownloadLink": iosDownloadLink,
      "updateDate": updateDate.toString(),
    };
  }
}
