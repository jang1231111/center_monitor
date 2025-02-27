  import 'package:package_info_plus/package_info_plus.dart';

Future<String> loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // (${packageInfo.buildNumber})
    return "${packageInfo.version}";
  }