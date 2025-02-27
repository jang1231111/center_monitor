import 'package:center_monitor/domain/entities/version/version.dart';

abstract class VersionRepository {
  Future<Version> getVersion();
}
