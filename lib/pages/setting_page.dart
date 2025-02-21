import 'package:center_monitor/constants/constants.dart';
import 'package:center_monitor/pages/my_page.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  static const String routeName = '/setting';
  const SettingPage({super.key});

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
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
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
                          kappVersion,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
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
    final loginInfo = context.read<CenterListProvider>().state.loginInfo;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '계정 정보',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // 테두리 색상
                    width: 1.0, // 테두리 두께
                  ),
                  borderRadius: BorderRadius.circular(12), // 테두리 둥글게 만들기
                ),
                child: InkWell(
                  onTap: () {
                    // Navigator.pushNamed(
                    //   context,
                    //   MyPage.routeName,
                    // );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${loginInfo.selectedCenter.centerNm}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${loginInfo.company}'),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 1, child: Icon(Icons.keyboard_arrow_right))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
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
                onTap: () {
                  // 로그아웃 기능 추가 가능
                },
              ),
              ListTile(
                leading: const Icon(Icons.verified_user_outlined),
                title: const Text('버전 체크'),
                onTap: () {
                  // 로그아웃 기능 추가 가능
                },
              ),
              const SizedBox(height: 20, child: Divider()),
              Text(
                '앱 사용자 설정',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: const Icon(Icons.monitor),
                title: const Text('화면 스타일'),
                onTap: () {
                  // 로그아웃 기능 추가 가능
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}


            //  const SizedBox(
            //           height: 10,
            //           child: Divider(),
            //         ),
            //         ListTile(
            //           leading: const Icon(Icons.announcement),
            //           title: const Text('공지 사항'),
            //           onTap: () {
            //             // 프로필 수정 기능 추가 가능
            //           },
            //         ),

                       //      ListTile(
                //   leading: const Icon(Icons.logout),
                //   title: const Text('로그아웃'),
                //   onTap: () {
                //     // 로그아웃 기능 추가 가능
                //   },
                // ),

                //      ListTile(
                //   leading: const Icon(Icons.logout),
                //   title: const Text('회원탈퇴'),
                //   onTap: () {
                //     // 로그아웃 기능 추가 가능
                //   },
                // ),