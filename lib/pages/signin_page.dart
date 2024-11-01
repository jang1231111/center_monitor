import 'package:center_monitor/constants/style.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/pages/main_page.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/providers/center_list/center_list_state.dart';
import 'package:center_monitor/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/providers/device_list/device_list_state.dart';
import 'package:center_monitor/widgets/center_choice_dialog.dart';
import 'package:center_monitor/widgets/error_dialog.dart';
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
      /// 센터 정보 API
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
      await Navigator.pushNamed(
        context,
        MainPage.routeName,
      );
    } on CustomError catch (e) {
      errorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final centerListState = context.watch<CenterListProvider>().state;
    final deviceListState = context.watch<DeviceListProvider>().state;

    return Container(
      color: Colors.white,
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
                          height: 130.0,
                        ),
                        Image.asset(
                          'assets/images/background.jpeg',
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
                                : Text(
                                    'login',
                                    textAlign: TextAlign.center,
                                    style: loginTitle(context),
                                  ).tr(),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          keyboardType: TextInputType.visiblePassword,
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'id'.tr(),
                            prefixIcon: Icon(Icons.login),
                          ),
                          validator: (String? value) {
                            // if (value == null || value.trim().isEmpty) {
                            //   return 'input id'.tr();
                            // }
                            // if (value.trim().length < 11)
                            //   return '로그인 번호는 11자리 전체를 입력해야 합니다.';
                            return null;
                          },
                          onSaved: (String? inputID) {
                            _ID = inputID;
                            _ID = 'health';
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          keyboardType: TextInputType.visiblePassword,
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'password'.tr(),
                            prefixIcon: Icon(Icons.password),
                          ),
                          validator: (String? value) {
                            // if (value == null || value.trim().isEmpty) {
                            //   return 'input password'.tr();
                            // }
                            // if (value.trim().length < 11)
                            //   return '로그인 번호는 11자리 전체를 입력해야 합니다.';
                            return null;
                          },
                          onSaved: (String? inputPassword) {
                            _Password = inputPassword;
                            _Password = 'health123';
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextButton.icon(
                          onPressed: null,
                          // centerListState.signinStatus == CenterListStatus.submitting
                          //     ? null
                          //     : () {
                          //         Navigator.pushNamed(
                          //             context, SignupPage.routeName);
                          //       },
                          icon: Icon(Icons.question_answer),
                          label: Text('forgot').tr(),
                          style: TextButton.styleFrom(
                              textStyle: TextStyle(
                            fontSize: 10.0,
                            decoration: TextDecoration.underline,
                          )),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ElevatedButton(
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
                            backgroundColor: Color.fromARGB(255, 38, 94, 176),
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          child: Divider(
                            height: 5,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 244, 242, 242),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'optilo',
                                style: optilo_name(context),
                              ).tr(),
                              Text(
                                'address',
                                style: optilo_info(context),
                              ).tr(),
                              Text(
                                'optiloHT',
                                style: optilo_info(context),
                              ).tr(),
                            ],
                          ),
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
