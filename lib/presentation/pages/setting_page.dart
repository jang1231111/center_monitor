import 'package:center_monitor/config/constants/constants.dart';
import 'package:center_monitor/presentation/pages/signin_page.dart';
import 'package:center_monitor/presentation/providers/notice/notice_provider.dart';
import 'package:center_monitor/core/utils/package_info.dart';
import 'package:center_monitor/presentation/widgets/dialog/logout_dialog.dart';
import 'package:center_monitor/presentation/widgets/dialog/notice_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  static const String routeName = '/setting';
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _appVersion = "Version";

  @override
  void initState() {
    super.initState();

    loadAppVersion().then(
      (value) {
        setState(() {
          _appVersion = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 246, 255, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.09,
            backgroundColor: Color.fromRGBO(254, 246, 255, 1),
            title: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    'assets/images/map.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '$_appVersion',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Color.fromRGBO(254, 246, 255, 1),
                      ),
                      // color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Column(
                          children: [
                            Setting(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    // bool isDark = context.watch<ThemeProvider>().themeMode == ThemeMode.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '계정',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await logoutDialog(context);

                    if (result == true) {
                      Navigator.pushNamed(context, SigninPage.routeName);
                    }
                  },
                  child: Text('로그아웃'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 239, 129, 28),
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(4)), // 네모난 모양으로 만들기
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20, child: Divider()),
              Text(
                '앱 정보',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.announcement),
                title: const Text('공지 사항'),
                onTap: () async {
                  final noticeProvider = context.read<NoticeProvider>();

                  await noticeProvider.getNotice();
                  final notice = noticeProvider.state.notice;
                  if (notice.useYn == 'Y') {
                    await showNoticeDialog(context, notice);
                  } else {
                    await showNoticeEmptyDialog(context);
                  }
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.verified_user_outlined),
              //   title: const Text('버전 체크'),
              //   onTap: () {
              //     // 로그아웃 기능 추가 가능
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.edit_document),
                title: const Text('개인정보 처리방침'),
                onTap: () async {
                  Uri uri = Uri.parse(koptiloPrivacyPolicyUri);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri,
                        mode: LaunchMode.externalApplication); // 외부 브라우저에서 열기
                  } else {
                    throw 'Could not launch $koptiloPrivacyPolicyUri';
                  }
                },
              ),
              // const SizedBox(height: 20, child: Divider()),
              // Text(
              //   '앱 사용자 설정',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              // ListTile(
              //   leading: const Icon(Icons.monitor),
              //   title: const Text('다크 모드'),
              //   trailing: Switch(
              //     value: isDark,
              //     onChanged: (value) {
              //       context.read<ThemeProvider>().toggleTheme(value);
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
