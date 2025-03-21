import 'package:center_monitor/domain/entities/center/center_list_info.dart';
import 'package:center_monitor/domain/entities/center/login_info.dart';
import 'package:center_monitor/domain/entities/error/custom_error.dart';
import 'package:center_monitor/presentation/providers/center_list/center_list_state.dart';
import 'package:center_monitor/data/datasources/remote/api_services.dart';

class CenterListRepositories {
  final ApiServices apiServices;

  CenterListRepositories({required this.apiServices});

  Future<CenterListState> signIn(
      {required String ID, required String Password}) async {
    try {
      String company;
      String token;
      List<CenterInfo> centerList;
      company = await apiServices.intergrationLogin(ID, Password);
      // print('IntergrationLogin Center Test $company');

      token = await apiServices.login(ID, Password, company);
      // print('login Token Test $token');

      centerList = await apiServices.getCenterList(token, company);
      print('getCenterList deviceList Test $centerList');

      CenterListInfo centerListInfo = CenterListInfo(centers: centerList);

      CenterListState centerListState = CenterListState(
          centerListStatus: CenterListStatus.submitting,
          centerListInfo: centerListInfo,
          loginInfo: LoginInfo(
              company: company,
              token: token,
              selectedCenter: CenterInfo.initial()),
          error: CustomError());
      // print(centerListInfo);

      return centerListState;
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
