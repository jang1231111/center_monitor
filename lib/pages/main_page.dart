import 'dart:convert';
import 'package:center_monitor/constants/style.dart';
import 'package:center_monitor/models/custom_error.dart';
import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/models/filter/device_filter.dart';
import 'package:center_monitor/pages/detail_page.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/providers/device_log_data/device_log_data_provider.dart';
import 'package:center_monitor/providers/device_filter/device_filter_provider.dart';
import 'package:center_monitor/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/providers/device_list/device_list_state.dart';
import 'package:center_monitor/providers/filtered_device/filtered_device_provider.dart';
import 'package:center_monitor/providers/login_number/login_number_provider.dart';
import 'package:center_monitor/widgets/error_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/main';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

final events = [];
bool canScroll = false;

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: canScroll
                  ? const ScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Listener(
                  onPointerDown: (event) {
                    events.add(event.pointer);
                    print("new event");
                  },
                  onPointerUp: (event) {
                    events.clear();
                    print("events cleared");
                    setState(() {
                      canScroll = true;
                    });
                  },
                  onPointerMove: (event) {
                    if (events.length == 2) {
                      setState(() {
                        canScroll = false;
                      });
                      //   int sensitivity = 8;
                      //   if (event.delta.dy > sensitivity) {
                      //     // code for two finger swipe up event

                      //   } else if (event.delta.dy < -sensitivity) {
                      //     // code for two finger swipe down event

                      //   }
                    }
                  },
                  child: Column(
                    children: [
                      ScanHeader(),
                      SizedBox(
                        child: Divider(height: 5),
                        height: 20,
                      ),
                      Text(
                        'centerPicture',
                        style: TextStyle(
                            color: Color.fromARGB(255, 38, 94, 176),
                            fontSize: 15.0),
                      ).tr(),
                      SizedBox(height: 10),
                      CenterPlan(),
                      SizedBox(
                        child: Divider(
                          height: 5,
                        ),
                        height: 20,
                      ),
                      Text(
                        'centerList',
                        style: TextStyle(
                            color: Color.fromARGB(255, 38, 94, 176),
                            fontSize: 15.0),
                      ).tr(),
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
      ),
    );
  }
}

class CenterPlan extends StatelessWidget {
  const CenterPlan({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceListState = context.watch<DeviceListProvider>().state;
    final devices =
        context.watch<DeviceListProvider>().state.deviceListInfo.devices;

    final String imageBase64 = context
        .read<CenterListProvider>()
        .state
        .loginInfo
        .selectedCenter
        .imageBaseUrl;

    return
        // GestureDetector(
        //     onTap: () {
        //       Navigator.pushNamed(context, CenterPlanPage.routeName);
        //     },
        //     child:
        InteractiveViewer(
      child: deviceListState.deviceListStatus == DeviceListStatus.submitting
          ? SizedBox()
          : Stack(
              children: [
                Container(
                    color: Colors.white,
                    child: Image.memory(
                      base64Decode(imageBase64),
                      fit: BoxFit.fill,
                      width: 400,
                      height: 300,
                    )),
                for (var device in devices)
                  Positioned(
                    left: device.positionX == null
                        ? null
                        : device.positionX! * 3.8,
                    top:
                        device.positionX == null ? null : device.positionY! * 3,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 91, 91, 91),
                        ),
                        width: 35,
                        height: 35,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/temp_ic.png',
                                    width: 10, height: 10, fit: BoxFit.fill),
                                Text(
                                  '${device.temp.toStringAsFixed(1)}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset('assets/images/ic_humidity.png',
                                    width: 10, height: 10, fit: BoxFit.fill),
                                Text(
                                  '${device.hum.floor()}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
              ],
            ),
    );
    // );
  }
}

class ShowUpdateTime extends StatelessWidget {
  const ShowUpdateTime({super.key});

  @override
  Widget build(BuildContext buildContext) {
    final updateTime = buildContext
        .watch<DeviceListProvider>()
        .state
        .deviceListInfo
        .updateTime;

    return ElevatedButton.icon(
      onPressed: () async {
        showDialog(
          context: buildContext,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                'centerInfo',
                style: Locate(context),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ).tr(),
              content: Text(
                'centerInfoMsg',
                style: End(context),
              ).tr(),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'no',
                    style: TextStyle(
                      color: Color.fromARGB(255, 38, 94, 176),
                    ),
                  ).tr(),
                ),
                TextButton(
                  onPressed: () async {
                    final selectedInfo =
                        context.read<CenterListProvider>().state.loginInfo;
                    final selectedCenterInfo = context
                        .read<CenterListProvider>()
                        .state
                        .loginInfo
                        .selectedCenter;

                    try {
                      Navigator.pop(context);
                      await context.read<DeviceListProvider>().getDeviceList(
                          id: selectedCenterInfo.id,
                          token: selectedInfo.token,
                          company: selectedInfo.company);
                    } on CustomError catch (e) {
                      errorDialog(buildContext, e.toString());
                    }
                  },
                  child: Text(
                    'yes',
                    style: TextStyle(
                      color: Color.fromARGB(255, 38, 94, 176),
                    ),
                  ).tr(),
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
        context.watch<FilteredDeviceProvider>().state.filtereCenterList;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${context.read<CenterListProvider>().state.loginInfo.company}',
          style: TextStyle(fontSize: 25.0),
        ),
        Text(
          'Number of centers : ${filteredCenterList.length}',
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
    final phoneNumber = context.read<LoginNumberProvider>().state.phoneNumber;
    return Column(
      children: [
        filterButton(context, Filter.all),
        phoneNumber == '010-9999-9999'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  filterButton(context, Filter.a),
                  filterButton(context, Filter.b),
                  filterButton(context, Filter.c),
                  filterButton(context, Filter.d),
                  filterButton(context, Filter.e),
                ],
              )
            : SizedBox(
                height: 5,
              )
      ],
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        context.read<DeviceFilterProvider>().changeFilter(filter);
      },
      child: Text(
        filter == Filter.all
            ? 'ALL'
            : filter == Filter.a
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
    final currentFilter = context.watch<DeviceFilterProvider>().state.filter;
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
        context.watch<FilteredDeviceProvider>().state.filtereCenterList;

    DeviceListState centerListState = context.watch<DeviceListProvider>().state;

    return centerListState.deviceListStatus == DeviceListStatus.submitting
        ? Center(
            child: Lottie.asset('assets/lottie/loading.json'),
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
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded(
                  //     flex: 5,
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //             color: Color.fromARGB(255, 38, 94, 176),
                  //             borderRadius: const BorderRadius.only(
                  //                 topLeft: Radius.circular(10),
                  //                 topRight: Radius.circular(10))),
                  //         width: MediaQuery.of(context).size.width * 1,
                  //         height: MediaQuery.of(context).size.height / 80)),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              '${device.centerNm} - ${device.deName}',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 54, 92, 1),
                                fontSize:
                                    MediaQuery.of(context).size.width / 28,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'pretend',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),

                            //  ElevatedButton(
                            //   onPressed: () {
                            //     showDialog(
                            //       context: context,
                            //       barrierDismissible: false,
                            //       builder: (context) {
                            //         return AlertDialog(
                            //           title: Text(
                            //             'centerInfo',
                            //             style: Locate(context),
                            //             overflow: TextOverflow.ellipsis,
                            //             maxLines: 1,
                            //             softWrap: false,
                            //           ).tr(),
                            //           content: Container(
                            //             width: 200,
                            //             height: 200,
                            //             child: Column(
                            //               children: [
                            //                 Row(
                            //                   children: [
                            //                     Text(
                            //                       'center',
                            //                       style: End(context),
                            //                       overflow:
                            //                           TextOverflow.ellipsis,
                            //                     ).tr(),
                            //                     Text(
                            //                       ': ${device.deName}',
                            //                       style: End(context),
                            //                       overflow:
                            //                           TextOverflow.ellipsis,
                            //                     )
                            //                   ],
                            //                 ),
                            //                 Row(
                            //                   children: [
                            //                     Text(
                            //                       'deviceInfo',
                            //                       style: End(context),
                            //                       overflow:
                            //                           TextOverflow.ellipsis,
                            //                     ).tr(),
                            //                     Text(
                            //                       ': ${device.deNumber}',
                            //                       style: End(context),
                            //                       overflow:
                            //                           TextOverflow.ellipsis,
                            //                     )
                            //                   ],
                            //                 ),
                            //                 Row(
                            //                   children: [
                            //                     Text(
                            //                       'description',
                            //                       style: End(context),
                            //                       overflow:
                            //                           TextOverflow.ellipsis,
                            //                     ).tr(),
                            //                     Text(
                            //                       ': ${device.description}',
                            //                       style: End(context),
                            //                       overflow:
                            //                           TextOverflow.ellipsis,
                            //                     )
                            //                   ],
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //           // Text(
                            //           //   '센터 : ${device.deName}\n기기 정보 : ${device.deNumber} \n설명 : ${device.description}',
                            //           //   style: End(context),
                            //           //   overflow: TextOverflow.ellipsis,
                            //           // ),
                            //           actions: [
                            //             TextButton(
                            //               onPressed: () {
                            //                 Navigator.pop(context);
                            //               },
                            //               child: Text(
                            //                 'ok',
                            //                 style: TextStyle(
                            //                   color: Color.fromARGB(
                            //                       255, 38, 94, 176),
                            //                 ),
                            //               ).tr(),
                            //             ),
                            //           ],
                            //         );
                            //       },
                            //     );
                            //   },
                            //   child: Text(
                            //     '${device.centerNm} - ${device.deName}',
                            //     style: TextStyle(
                            //       color: Color.fromRGBO(0, 54, 92, 1),
                            //       fontSize:
                            //           MediaQuery.of(context).size.width / 30,
                            //       fontWeight: FontWeight.w700,
                            //       fontFamily: 'pretend',
                            //     ),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 1,
                            //     softWrap: false,
                            //   ),
                            // ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
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
                                          'checkData',
                                          style: Locate(context),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                        ).tr(),
                                        content: Container(
                                          width: 200,
                                          height: 100,
                                          child: Column(
                                            children: [
                                              Text(
                                                '${device.deName}',
                                                style: End(context),
                                              ),
                                              Text(
                                                'checkDataMsg',
                                                style: End(context),
                                              ).tr(),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'no',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 38, 94, 176),
                                              ),
                                            ).tr(),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final selectedCenterInfo = context
                                                  .read<CenterListProvider>()
                                                  .state
                                                  .loginInfo;

                                              try {
                                                A10 newDevice = device.copyWith(
                                                  startTime: DateTime.utc(
                                                      device.timeStamp.year,
                                                      device.timeStamp.month,
                                                      device.timeStamp.day),
                                                );

                                                await context
                                                    .read<
                                                        DeviceLogDataProvider>()
                                                    .getDeviceLogData(
                                                        device: newDevice,
                                                        token:
                                                            selectedCenterInfo
                                                                .token,
                                                        company:
                                                            selectedCenterInfo
                                                                .company);
                                                Navigator.pop(context);
                                                Navigator.pushNamed(context,
                                                    DetailPage.routeName,
                                                    arguments:
                                                        newDevice.copyWith());
                                              } on CustomError catch (e) {
                                                errorDialog(
                                                    context, e.toString());
                                              }
                                            },
                                            child: Text(
                                              'yes',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 38, 94, 176),
                                              ),
                                            ).tr(),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'checkData',
                                  style: TextStyle(color: Colors.white),
                                ).tr()),
                          ),
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
                    flex: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/images/temp_ic.png'),
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width * 0.08,
                                height:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                              Text(
                                '${device.temp}°C',
                                style: TextStyle(
                                  color: Color.fromRGBO(230, 76, 76, 1),
                                  fontSize:
                                      MediaQuery.of(context).size.width / 23,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'pretend',
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image:
                                    AssetImage('assets/images/ic_humidity.png'),
                                fit: BoxFit.contain,
                                width: MediaQuery.of(context).size.width * 0.08,
                                height:
                                    MediaQuery.of(context).size.width * 0.08,
                              ),
                              Text(
                                '${device.hum}%',
                                style: TextStyle(
                                  color: Color.fromRGBO(72, 151, 219, 1),
                                  fontSize:
                                      MediaQuery.of(context).size.width / 23,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'pretend',
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getbatteryImage(context, device.battery),
                              Text(
                                '${device.battery}%',
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 136, 79, 1),
                                  fontSize:
                                      MediaQuery.of(context).size.width / 23,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'pretend',
                                ),
                              )
                            ],
                          ),
                        )
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
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Text(
                                    '권장 온도 : ${device.deLocation} (${device.tempLow}°C~${device.tempHigh}°C)',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                40,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'pretend',
                                        color: Color.fromRGBO(90, 90, 90, 1)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Text(
                                    '비고: ${device.description}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                40,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'pretend',
                                        color: Color.fromRGBO(90, 90, 90, 1)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
