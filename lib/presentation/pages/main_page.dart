import 'dart:convert';
import 'package:bitmap/bitmap.dart';
import 'package:center_monitor/config/constants/style.dart';
import 'package:center_monitor/domain/entities/error/custom_error.dart';
import 'package:center_monitor/domain/entities/device/device_list_info.dart';
import 'package:center_monitor/domain/entities/filter/device_filter.dart';
import 'package:center_monitor/presentation/pages/center_plan_page.dart';
import 'package:center_monitor/presentation/pages/detail_page.dart';
import 'package:center_monitor/presentation/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/presentation/providers/device_log_data/device_log_data_provider.dart';
import 'package:center_monitor/presentation/providers/device_filter/device_filter_provider.dart';
import 'package:center_monitor/presentation/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/presentation/providers/device_list/device_list_state.dart';
import 'package:center_monitor/presentation/providers/center_search/center_search_provider.dart';
import 'package:center_monitor/presentation/providers/filtered_device/filtered_device_provider.dart';
import 'package:center_monitor/core/utils/debounce.dart';
import 'package:center_monitor/presentation/providers/notice/notice_provider.dart';
import 'package:center_monitor/presentation/widgets/error_dialog.dart';
import 'package:center_monitor/presentation/widgets/notice_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final repaintBoundary = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final devices =
        context.watch<DeviceListProvider>().state.deviceListInfo.devices;

    final noticeProvider = context.read<NoticeProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await noticeProvider.getNotice();
        final notice = noticeProvider.state.notice;
        if (notice.useYn == 'Y') {
          await showNoticeDialog(context, notice);
        }
      },
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 246, 255, 1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: size.height * 0.75,
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
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        Container(
                          width: width,
                          color: Color.fromRGBO(254, 246, 255, 1),
                          child: Stack(
                            children: [
                              RepaintBoundary(
                                key: repaintBoundary,
                                child: InkWell(
                                  onLongPress: () async {
                                    final boundary = repaintBoundary
                                            .currentContext!
                                            .findRenderObject()
                                        as RenderRepaintBoundary;
                                    final image =
                                        await boundary.toImage(pixelRatio: 2);

                                    final bytedata = await image.toByteData();
                                    Bitmap bitmap = Bitmap.fromHeadless(
                                        image.width,
                                        image.height,
                                        bytedata!.buffer.asUint8List());

                                    Navigator.pushNamed(
                                        context, CenterPlanPage.routeName,
                                        arguments: bitmap);
                                  },
                                  child: Stack(
                                    children: [
                                      CenterImage(),
                                      for (var device in devices)
                                        Positioned(
                                          left: device.positionX == null
                                              ? null
                                              : (device.positionX! *
                                                      (width - 40)) /
                                                  100,
                                          top: device.positionX == null
                                              ? null
                                              : (device.positionY! *
                                                      height *
                                                      0.3) /
                                                  100,
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      '${device.centerNm}',
                                                      style: Locate(context),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                    ),
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'no',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    38,
                                                                    94,
                                                                    176),
                                                          ),
                                                        ).tr(),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          final selectedCenterInfo =
                                                              context
                                                                  .read<
                                                                      CenterListProvider>()
                                                                  .state
                                                                  .loginInfo;
                                                          try {
                                                            A10 newDevice =
                                                                device.copyWith(
                                                              startTime: DateTime.utc(
                                                                  device
                                                                      .timeStamp
                                                                      .year,
                                                                  device
                                                                      .timeStamp
                                                                      .month,
                                                                  device
                                                                      .timeStamp
                                                                      .day),
                                                            );

                                                            await context
                                                                .read<
                                                                    DeviceLogDataProvider>()
                                                                .getDeviceLogData(
                                                                    device:
                                                                        newDevice,
                                                                    token: selectedCenterInfo
                                                                        .token,
                                                                    company:
                                                                        selectedCenterInfo
                                                                            .company);
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pushNamed(
                                                                context,
                                                                DetailPage
                                                                    .routeName,
                                                                arguments: newDevice
                                                                    .copyWith());
                                                          } on CustomError catch (e) {
                                                            errorDialog(context,
                                                                e.toString());
                                                          }
                                                        },
                                                        child: Text(
                                                          'yes',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    38,
                                                                    94,
                                                                    176),
                                                          ),
                                                        ).tr(),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                color: Color.fromARGB(
                                                    255, 91, 91, 91),
                                              ),
                                              width: 25,
                                              height: 23,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/temp_ic.png',
                                                          width: 7,
                                                          height: 7,
                                                          fit: BoxFit.fill),
                                                      Text(
                                                        '${device.temp.toStringAsFixed(1)}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 7),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/ic_humidity.png',
                                                          width: 7,
                                                          height: 7,
                                                          fit: BoxFit.fill),
                                                      Text(
                                                        '${device.hum.floor()}%',
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 7),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
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
                        SizedBox(height: 10),
                        SizedBox(
                          child: Divider(
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Column(
                      children: [
                        FilterCenter(),
                        ShowUpdateTime(),
                        SizedBox(height: 10),
                        SearchDevice(),
                        SizedBox(height: 10),
                        ShowDevices(),
                      ],
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

class SearchDevice extends StatelessWidget {
  SearchDevice({super.key});
  final debounce = Debounce(millonseconds: 500);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.80,
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search Center',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)), // 둥근 테두리
            borderSide: BorderSide.none, // 기본 테두리 제거
          ),
          filled: true,
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (String? newSearchTerm) {
          if (newSearchTerm != null) {
            debounce.run(
              () {
                context
                    .read<CenterSearchProvider>()
                    .setSearchTerm(newSearchTerm);
              },
            );
          }
        },
      ),
    );
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
      icon: Icon(Icons.refresh, color: Color.fromARGB(255, 38, 94, 176)),
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

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${context.read<CenterListProvider>().state.loginInfo.selectedCenter.centerNm}',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
          ),
          Text(
            'Number of centers : ${filteredCenterList.length}',
            style: TextStyle(
              fontSize: 15.0,
              color: Color.fromARGB(255, 241, 140, 31),
            ),
          )
        ],
      ),
    );
  }
}

class FilterCenter extends StatelessWidget {
  FilterCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        filterButton(context, Filter.all),
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
    return currentFilter == filter
        ? Color.fromARGB(255, 38, 94, 176)
        : Colors.grey;
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
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            itemCount: filteredCenterList.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 40,
                // color: Colors.grey,
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
                            child: ElevatedButton(
                              child: Text(
                                'checkData',
                                style: TextStyle(color: Colors.white),
                              ).tr(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 38, 94, 176),
                                foregroundColor: Colors.white,
                                textStyle: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8)), // 네모난 모양으로 만들기
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        '${device.centerNm}',
                                        style: Locate(context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
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
                                        ElevatedButton(
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
                                                  .read<DeviceLogDataProvider>()
                                                  .getDeviceLogData(
                                                      device: newDevice,
                                                      token: selectedCenterInfo
                                                          .token,
                                                      company:
                                                          selectedCenterInfo
                                                              .company);
                                              Navigator.pop(context);
                                              Navigator.pushNamed(
                                                  context, DetailPage.routeName,
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
                            ),
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
                                  color: getBatteryColor(device.battery),
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
