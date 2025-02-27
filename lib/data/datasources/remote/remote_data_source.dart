import 'package:center_monitor/config/constants/constants.dart';
import 'package:center_monitor/data/datasources/models/version_model.dart';
import 'package:center_monitor/data/datasources/remote/api_services.dart';

class RemoteDataSource {
  final ApiServices _apiServices;

  RemoteDataSource(this._apiServices);

  Future<VersionModel> fetchVersion() async {
    final response = await _apiServices.get('$khttpUri$kgetVersionUri');
    return VersionModel.fromMap(response);
  }
}
