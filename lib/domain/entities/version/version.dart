class Version {
  String latestVersion;
  String androidDownloadLink;
  String iosDownloadLink;
  DateTime updateDate;
  Version({
    required this.latestVersion,
    required this.androidDownloadLink,
    required this.iosDownloadLink,
    required this.updateDate,
  });

  @override
  String toString() {
    return 'Version(latestVersion: $latestVersion, androidDownloadLink: $androidDownloadLink, iosDownloadLink: $iosDownloadLink, updateDate: $updateDate)';
  }
}
