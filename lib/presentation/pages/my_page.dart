import 'dart:convert';

import 'package:center_monitor/config/constants/style.dart';
import 'package:center_monitor/presentation/providers/center_list/center_list_provider.dart';
import 'package:easy_localization/easy_localization.dart';
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
                                '${context.read<CenterListProvider>().state.loginInfo.selectedCenter.centerNm}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
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
                            child: Padding(
                              padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '센터 도면',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                  CenterImage(),
                                  SizedBox(height: 20),
                                  Text(
                                    '센터 정보',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[900],
                                    ),
                                  ),
                                  CenterInfomation(),
                                  SizedBox(
                                    child: Divider(
                                      height: 70,
                                    ),
                                  ),
                                  OptiloInfo(),
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
          ),
        ),
      ),
    );
  }
}

class CenterImage extends StatelessWidget {
  const CenterImage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final String imageBase64 = context
        .read<CenterListProvider>()
        .state
        .loginInfo
        .selectedCenter
        .imageBaseUrl;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // 아래쪽 어두운 그림자
              offset: Offset(8, 8),
              blurRadius: 16,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.white70,
              offset: Offset(-8, -8),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.memory(
            base64Decode(imageBase64),
            fit: BoxFit.fill,
            width: width,
            height: height * 0.3,
            gaplessPlayback: true,
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

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(254, 246, 255, 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.white70,
              offset: Offset(-8, -8),
              blurRadius: 16,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black26, // 아래쪽 어두운 그림자
              offset: Offset(8, 8),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListTile(
                    leading: const Icon(Icons.factory,
                        color: Color.fromARGB(255, 38, 199, 172)),
                    title: Text(
                      '센터명',
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                    subtitle: Text("${loginInfo.selectedCenter.centerNm}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListTile(
                    leading: const Icon(Icons.numbers, color: Colors.black),
                    title: Text(
                      '센터 번호',
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                    subtitle: Text("${loginInfo.selectedCenter.centerSn}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListTile(
                    leading: const Icon(Icons.all_inclusive,
                        color: Color.fromARGB(255, 38, 199, 172)),
                    title: Text(
                      '전체',
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                    subtitle: Text("${loginInfo.selectedCenter.total}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListTile(
                    leading: const Icon(Icons.disabled_by_default,
                        color: Color.fromARGB(255, 249, 177, 0)),
                    title: Text(
                      '비활성기기',
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                    subtitle: Text("${loginInfo.selectedCenter.inactive}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListTile(
                    leading: const Icon(Icons.thermostat,
                        color: Color.fromARGB(255, 252, 145, 175)),
                    title: Text(
                      '온도 경고',
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                    subtitle: Text("${loginInfo.selectedCenter.tempWarn}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListTile(
                    leading: const Icon(Icons.water,
                        color: Color.fromARGB(255, 53, 149, 255)),
                    title: Text(
                      '습도 경고',
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                    subtitle: Text("${loginInfo.selectedCenter.humWarn}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OptiloInfo extends StatelessWidget {
  const OptiloInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 244, 242, 242),
        boxShadow: [
          BoxShadow(
            color: Colors.white70,
            offset: Offset(-8, -8),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black26, // 아래쪽 어두운 그림자
            offset: Offset(8, 8),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
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
    );
  }
}
