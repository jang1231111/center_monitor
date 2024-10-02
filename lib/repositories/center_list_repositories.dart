import 'package:center_monitor/models/center/center_list_info.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/serivices/api_services.dart';

class CenterListRepositories {
  final ApiServices apiServices;

  CenterListRepositories({required this.apiServices});

  Future<CenterListInfo> signIn(
      {required String ID, required String Password}) async {
    try {
      String center;
      String token;
      List<Center> centerList;

      center = await apiServices.intergrationLogin(ID, Password);
      // print('IntergrationLogin Center Test $center');

      token = await apiServices.login(ID, Password, center);
      // print('login Token Test $token');

      centerList = await apiServices.getCenterList(token, center);
      // print('getCenterList deviceList Test $centerList');

      CenterListInfo centerListInfo = CenterListInfo(centers: centerList);
      print(centerListInfo);

      return centerListInfo;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
