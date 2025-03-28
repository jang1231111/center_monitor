import 'package:center_monitor/config/constants/constants.dart';
import 'package:center_monitor/config/constants/style.dart';
import 'package:center_monitor/domain/entities/error/custom_error.dart';
import 'package:center_monitor/presentation/pages/navigation_page.dart';
import 'package:center_monitor/presentation/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/presentation/providers/center_list/center_list_state.dart';
import 'package:center_monitor/presentation/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/presentation/providers/device_list/device_list_state.dart';
import 'package:center_monitor/presentation/providers/version/version_provider.dart';
import 'package:center_monitor/presentation/widgets/dialog/version_check_dialog.dart';
import 'package:center_monitor/presentation/widgets/button/webPageButton.dart';
import 'package:center_monitor/presentation/widgets/dialog/center_choice_dialog.dart';
import 'package:center_monitor/presentation/widgets/dialog/error_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});
  static const String routeName = '/signin';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _ID;
  String? _Password;

  void _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    form.save();

    try {
      /// 센터 정보 API // 아래 수정해야함 테스트용
      await context
          .read<CenterListProvider>()
          .signIn(ID: _ID!, Password: _Password!);

      /// 센터 선택 Dialog
      final center = await showCenterChoiceDialog(context,
          context.read<CenterListProvider>().state.centerListInfo.centers);

      context.read<CenterListProvider>().changeSelectedCenterInfo(center);

      final selectedInfo = context.read<CenterListProvider>().state.loginInfo;

      /// 기기 정보 API
      await context.read<DeviceListProvider>().getDeviceList(
          id: center.id,
          token: selectedInfo.token,
          company: selectedInfo.company);

      /// 화면 전환
      await Navigator.pushNamed(context, NavigationPage.routeName);
    } on CustomError catch (e) {
      errorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final centerListState = context.watch<CenterListProvider>().state;
    final deviceListState = context.watch<DeviceListProvider>().state;
    final versionProvider = context.read<VersionProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await versionProvider.checkForUpdate();
        if (versionProvider.state.isUpdateRequired) {
          await showVersionUpdateDialog(
              context, versionProvider.state.downloadLink!);
        }
      },
    );

    return Container(
      color: Color.fromRGBO(254, 246, 255, 1),
      child: SafeArea(
        child: PopScope(
          canPop: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateMode,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 150.0,
                        ),
                        Image.asset(
                          'assets/images/optilo_logo.png',
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        centerListState.centerListStatus ==
                                CenterListStatus.submitting
                            ? Lottie.asset('assets/lottie/loading.json',
                                width: 100, height: 100)
                            : deviceListState.deviceListStatus ==
                                    DeviceListStatus.submitting
                                ? Lottie.asset('assets/lottie/loading.json',
                                    width: 100, height: 100)
                                : SizedBox(),
                        SizedBox(
                          height: 30.0,
                        ),
                        Align(
                          child: SizedBox(
                            width: 350,
                            child: TextFormField(
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              keyboardType: TextInputType.visiblePassword,
                              autocorrect: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: optiloBlue,
                                      width: 2.0), // 포커스 시 테두리 색상
                                ),
                                filled: true,
                                labelText: 'id'.tr(),
                                prefixIcon: Icon(Icons.login),
                              ),
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'input id'.tr();
                                }
                                // if (value.trim().length < 11)
                                //   return '로그인 번호는 11자리 전체를 입력해야 합니다.';
                                return null;
                              },
                              onSaved: (String? inputID) {
                                _ID = inputID;
                                // _ID = 'health';
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          child: SizedBox(
                            width: 350,
                            child: TextFormField(
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              keyboardType: TextInputType.visiblePassword,
                              autocorrect: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: optiloBlue,
                                      width: 2.0), // 포커스 시 테두리 색상
                                ),
                                filled: true,
                                labelText: 'password'.tr(),
                                prefixIcon: Icon(Icons.password),
                              ),
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'input password'.tr();
                                }
                                // if (value.trim().length < 11)
                                //   return '로그인 번호는 11자리 전체를 입력해야 합니다.';
                                // return null;
                              },
                              onSaved: (String? inputPassword) {
                                _Password = inputPassword;
                                // _Password = 'health123';
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Align(
                          child: SizedBox(
                            width: 350,
                            child: ElevatedButton(
                              onPressed: centerListState.centerListStatus ==
                                      CenterListStatus.submitting
                                  ? null
                                  : _submit,
                              child: Text(centerListState.centerListStatus ==
                                          CenterListStatus.submitting
                                      ? 'loading'
                                      : 'sign in')
                                  .tr(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: optiloBlue,
                                foregroundColor: Colors.white,
                                textStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(4)), // 네모난 모양으로 만들기
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WebPageButton(
                              text: '비밀번호 찾기',
                              url: kforgotPasswordUri,
                              color: Colors.grey[700]!,
                            ),
                            WebPageButton(
                              text: '회원 가입',
                              url: ksignUpUri,
                              color: Color.fromRGBO(38, 94, 176, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
