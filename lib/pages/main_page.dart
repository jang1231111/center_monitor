import 'package:center_monitor/constants/style.dart';
import 'package:center_monitor/models/a10_model.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/pages/center_plan_page.dart';
import 'package:center_monitor/pages/detail_page.dart';
import 'package:center_monitor/providers/center_data/center_data_provider.dart';
import 'package:center_monitor/providers/center_filter/center_filter_provider.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/providers/center_list/center_list_state.dart';
import 'package:center_monitor/providers/filtered_center/filtered_center_provider.dart';
import 'package:center_monitor/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  static const String routeName = '/main';
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Column(
                  children: [
                    ScanHeader(),
                    SizedBox(
                      child: Divider(height: 5),
                      height: 20,
                    ),
                    Text(
                      '센터 도면',
                      style: TextStyle(
                          color: Color.fromARGB(255, 38, 94, 176),
                          fontSize: 15.0),
                    ),
                    SizedBox(height: 10),
                    CenterPlan(),
                    SizedBox(
                      child: Divider(
                        height: 5,
                      ),
                      height: 20,
                    ),
                    Text(
                      '센터 리스트',
                      style: TextStyle(
                          color: Color.fromARGB(255, 38, 94, 176),
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ShowUpdateTime(),
                    SizedBox(
                      height: 10,
                    ),
                    FilterCenter(),
                    ShowDevices(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CenterPlan extends StatelessWidget {
  const CenterPlan({super.key});

  @override
  Widget build(BuildContext context) {
    final devices =
        context.read<CenterListProvider>().state.centerListInfo.devices;

    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, CenterPlanPage.routeName);
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                color: Colors.white,
                // child: Image.asset('assets/images/center.png'),
                child: Image.network(
                  // fit: BoxFit.fill,
                  'http://geo.logithermo.com/upload/center/geo/위험물%20인성창고.jpg',
                  // width: 400,
                  // height: 300,
                ),
                padding: const EdgeInsets.all(2),
              ),
            ),
            // for (var device in devices)
            //   Positioned(
            //     left: device.positionX * 4,
            //     top: device.positionY * 3,
            //     child: Container(
            //       child: Text(
            //         device.hum,
            //         style: TextStyle(color: Colors.red),
            //       ),
            //     ),
            //   ),
          ],
        ));
  }
}

class ShowUpdateTime extends StatelessWidget {
  const ShowUpdateTime({super.key});

  @override
  Widget build(BuildContext buildContext) {
    final updateTime = buildContext
        .watch<CenterListProvider>()
        .state
        .centerListInfo
        .updateTime;

    return ElevatedButton.icon(
      onPressed: () async {
        showDialog(
          context: buildContext,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                '센터 정보',
                style: Locate(context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
              content: Text(
                '센터 정보를 새롭게 불러오시겠습니까?',
                style: End(context),
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    '아니오',
                    style: TextStyle(
                      color: Color.fromARGB(255, 38, 94, 176),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      Navigator.pop(context);
                      await context
                          .read<CenterListProvider>()
                          .getCenterList(phoneNumber: 'phoneNumber');
                    } on CustomError catch (e) {
                      errorDialog(buildContext, e.toString());
                    }
                  },
                  child: Text(
                    '예',
                    style: TextStyle(
                      color: Color.fromARGB(255, 38, 94, 176),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      icon: Icon(Icons.refresh),
      label: Text('${DateFormat("MM/dd hh:mm:ss aa").format(updateTime)}'),
      style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          textStyle: TextStyle(
            fontSize: 15.0,
          )),
    );
  }
}

class ScanHeader extends StatelessWidget {
  const ScanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final filteredCenterList =
        context.watch<FilteredCenterProvider>().state.filtereCenterList;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          // 로그인 화면 구현 시, 사용자 정보 받아들여와 센터 이름으로 표시 처리
          '인성 창고',
          style: TextStyle(fontSize: 25.0),
        ),
        Text(
          '센터 개수 : ${filteredCenterList.length}',
          style: TextStyle(
            fontSize: 15.0,
            color: Color.fromARGB(255, 241, 140, 31),
          ),
        )
      ],
    );
  }
}

class FilterCenter extends StatelessWidget {
  FilterCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filterButton(context, Filter.a),
            filterButton(context, Filter.b),
            filterButton(context, Filter.c),
            filterButton(context, Filter.d),
            filterButton(context, Filter.e),
          ],
        )
      ],
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        context.read<CenterFilterProvider>().changeFilter(filter);
      },
      child: Text(
        filter == Filter.a
            ? '가동'
            : filter == Filter.b
                ? '나동'
                : filter == Filter.c
                    ? '다동'
                    : filter == Filter.d
                        ? '라동'
                        : '마동',
        style: TextStyle(
          fontSize: 18.0,
          color: textColor(context, filter),
        ),
      ),
    );
  }

  Color textColor(BuildContext context, Filter filter) {
    final currentFilter = context.watch<CenterFilterProvider>().state.filter;
    return currentFilter == filter ? Colors.blue : Colors.grey;
  }
}

class ShowDevices extends StatefulWidget {
  const ShowDevices({super.key});

  @override
  State<ShowDevices> createState() => _ShowDevicesState();
}

class _ShowDevicesState extends State<ShowDevices> {
  // late Timer updateTimer;

  @override
  void initState() {
    super.initState();
    // startUpdateTimer();
  }

  @override
  void dispose() {
    // updateTimer.cancel();
    super.dispose();
  }

  // startUpdateTimer() {
  //   updateTimer = Timer.periodic(
  //     Duration(minutes: 5),
  //     (timer) async {
  //       await context
  //           .read<CenterListProvider>()
  //           .getCenterList(phoneNumber: 'phoneNumber');
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final filteredCenterList =
        context.watch<FilteredCenterProvider>().state.filtereCenterList;

    CenterListState centerListState = context.watch<CenterListProvider>().state;

    return centerListState.centerListStatus == CenterListStatus.submitting
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: filteredCenterList.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Colors.grey,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return DeviceItem(device: filteredCenterList[index].copyWith());
            },
          );
  }
}

class DeviceItem extends StatelessWidget {
  final A10 device;
  const DeviceItem({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [mainbox()],
              ),
              height: MediaQuery.of(context).size.height * 0.18,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 5,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 38, 94, 176),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height / 80)),
                  Expanded(
                    flex: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        '기기 정보',
                                        style: Locate(context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                      content: Text(
                                        '센터 : ${device.deName}\n기기 정보 : ${device.deNumber}',
                                        style: End(context),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            '확인',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 38, 94, 176),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                device.deName,
                                style: Locate(context),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Color.fromARGB(255, 38, 94, 176))),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        '데이터 확인',
                                        style: Locate(context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                      content: Text(
                                        '${device.deName} 의 \n데이터를 확인하시겠습니까?',
                                        style: End(context),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            '아니오',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 38, 94, 176),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await context
                                                  .read<CenterDataProvider>()
                                                  .getCenterData(
                                                      device: device);
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, DetailPage.routeName,
                                                  arguments: device.copyWith());
                                            } on CustomError catch (e) {
                                              errorDialog(
                                                  context, e.toString());
                                            }
                                          },
                                          child: Text(
                                            '예',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 38, 94, 176),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                '확 인',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    child: Divider(
                      height: 10,
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Image.asset('assets/images/temp_ic.png',
                                    fit: BoxFit.fill),
                              ),
                              Text(
                                '${device.temp}°C',
                                style: Temp(context),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Image.asset(
                                    'assets/images/ic_humidity.png',
                                    fit: BoxFit.fill),
                              ),
                              Text(
                                '${device.hum}%',
                                style: Temp(context),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getbatteryImage(
                                  context, int.parse(device.battery)),
                              Text(
                                '${device.battery}%',
                                style: Temp(context),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
