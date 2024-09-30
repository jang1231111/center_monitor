import 'package:center_monitor/constants/style.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/pages/main_page.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/providers/center_list/center_list_state.dart';
import 'package:center_monitor/providers/login_number/login_number_provider.dart';
import 'package:center_monitor/widgets/center_choice_dialog.dart';
import 'package:center_monitor/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
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
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    form.save();

    try {
      await context
          .read<CenterListProvider>()
          .signIn(ID: _ID!, Password: _Password!);
      showDialog(
        context: context,
        builder: (context) => CenterChoiceDialog(centers: ['a']),
      );
      // context.read<LoginNumberProvider>().changeLoginNumber(_phoneNumber!);
      // Navigator.pushNamed(context, MainPage.routeName);
    } on CustomError catch (e) {
      showDialog(
        context: context,
        builder: (context) => CenterChoiceDialog(centers: ['a']),
      );
      errorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final centerListState = context.watch<CenterListProvider>().state;

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
                          height: 80.0,
                        ),
                        Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: loginTitle(context),
                        ),
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
                            labelText: '아이디',
                            prefixIcon: Icon(Icons.login),
                          ),
                          validator: (String? value) {
                            // if (value == null || value.trim().isEmpty) {
                            //   return '아이디를 입려하세요';
                            // }
                            // if (value.trim().length < 11)
                            //   return '로그인 번호는 11자리 전체를 입력해야 합니다.';
                            return null;
                          },
                          onSaved: (String? inputID) {
                            _ID = inputID;
                            _ID = 'insung';
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
                            labelText: '비밀번호',
                            prefixIcon: Icon(Icons.password),
                          ),
                          validator: (String? value) {
                            // if (value == null || value.trim().isEmpty) {
                            //   return '비밀번호를 입려하세요';
                            // }
                            // if (value.trim().length < 11)
                            //   return '로그인 번호는 11자리 전체를 입력해야 합니다.';
                            return null;
                          },
                          onSaved: (String? inputPassword) {
                            _Password = inputPassword;
                            _Password = 'insung123';
                          },
                        ),
                        // TextButton.icon(
                        //   onPressed: null,
                        //   // centerListState.signinStatus == CenterListStatus.submitting
                        //   //     ? null
                        //   //     : () {
                        //   //         Navigator.pushNamed(
                        //   //             context, SignupPage.routeName);
                        //   //       },
                        //   icon: Icon(Icons.question_answer),
                        //   label: Text('Forgot Login Number?'),
                        //   style: TextButton.styleFrom(
                        //       textStyle: TextStyle(
                        //     fontSize: 10.0,
                        //     decoration: TextDecoration.underline,
                        //   )),
                        // ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: centerListState.centerListStatus ==
                                  CenterListStatus.submitting
                              ? null
                              : _submit,
                          child: Text(centerListState.centerListStatus ==
                                  CenterListStatus.submitting
                              ? 'Loading...'
                              : 'Sign in'),
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
                          height: 50.0,
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
                                '(주)옵티로',
                                style: optilo_name(context),
                              ),
                              Text(
                                '인천광역시 연수구 송도미래로 30 스마트밸리 D동',
                                style: optilo_info(context),
                              ),
                              Text(
                                'H : www.optilo.net  T : 070-5143-8585',
                                style: optilo_info(context),
                              ),
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
