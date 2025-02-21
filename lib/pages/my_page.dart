import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  static const String routeName = '/my';
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: true,
      child: Container(
        color: Color.fromRGBO(254, 246, 255, 1),
        child: SafeArea(
          top: true,
          bottom: false,
          child: Scaffold(
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
                                'Center Information',
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
                                children: [CenterInfomation()],
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
          ),
        ),
      ),
    );
  }
}

class CenterInfomation extends StatelessWidget {
  const CenterInfomation({super.key});

  @override
  Widget build(BuildContext context) {
    final loginInfo = context.read<CenterListProvider>().state.loginInfo;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.announcement),
          title: Text('CenterNm : ${loginInfo.selectedCenter.centerNm}'),
          onTap: () {
            // 로그아웃 기능 추가 가능
          },
        ),
        ListTile(
          leading: const Icon(Icons.announcement),
          title: Text('CenterSn : ${loginInfo.selectedCenter.centerSn}'),
          onTap: () {
            // 로그아웃 기능 추가 가능
          },
        ),
        ListTile(
          leading: const Icon(Icons.announcement),
          title: Text('CenterNm : ${loginInfo.selectedCenter.humWarn}'),
          onTap: () {
            // 로그아웃 기능 추가 가능
          },
        ),
        ListTile(
          leading: const Icon(Icons.announcement),
          title: Text('CenterId : ${loginInfo.selectedCenter.id}'),
          onTap: () {
            // 로그아웃 기능 추가 가능
          },
        ),
        ListTile(
          leading: const Icon(Icons.announcement),
          title: Text('Inactive : ${loginInfo.selectedCenter.inactive}'),
          onTap: () {
            // 로그아웃 기능 추가 가능
          },
        ),
        ListTile(
          leading: const Icon(Icons.announcement),
          title: Text('TempWarn : ${loginInfo.selectedCenter.tempWarn}'),
          onTap: () {
            // 로그아웃 기능 추가 가능
          },
        ),
        ListTile(
          leading: const Icon(Icons.announcement),
          title: Text('Total : ${loginInfo.selectedCenter.total}'),
          onTap: () {
            // 로그아웃 기능 추가 가능
          },
        ),
      ],
    );
  }
}
