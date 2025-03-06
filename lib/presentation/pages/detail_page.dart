import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart' as ex;
import 'package:center_monitor/config/constants/style.dart';
import 'package:center_monitor/domain/entities/error/custom_error.dart';
import 'package:center_monitor/domain/entities/device/device_list_info.dart';
import 'package:center_monitor/domain/entities/device/device_logdata_info.dart';
import 'package:center_monitor/presentation/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/presentation/providers/device_log_data/device_log_data_provider.dart';
import 'package:center_monitor/presentation/providers/device_log_data/device_log_data_state.dart';
import 'package:center_monitor/presentation/providers/device_report/device_report_provider.dart';
import 'package:center_monitor/presentation/providers/device_report/device_report_state.dart';
import 'package:center_monitor/presentation/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailPage extends StatelessWidget {
  static const String routeName = '/detail';
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 254, 246, 255),
      child: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 254, 246, 255),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  DetailHeader(),
                  SizedBox(
                    child: Divider(
                      height: 5,
                    ),
                    height: 20,
                  ),
                  Text(
                    '온도 그래프',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),

                  dataChart(),

                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 5,
                    child: logInformation(),
                  ),
                  SizedBox(
                    child: Divider(height: 5),
                    height: 20,
                  ),
                  // Expanded(flex: 1, child: OptiloInfo()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    A10 device = ModalRoute.of(context)!.settings.arguments as A10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
              padding: EdgeInsets.zero, // 내부 패딩 없애기
            ),
            Text(
              'detailInfo',
              style: TextStyle(fontSize: 25.0),
            ).tr(),
          ],
        ),

        // Text(
        //   'detailInfo',
        //   style: TextStyle(fontSize: 25.0),
        // ).tr(),
        Text(
          '${device.centerNm} - ${device.deName}',
          style: TextStyle(
            fontSize: 15.0,
            color: Color.fromARGB(255, 241, 140, 31),
          ),
        )
      ],
    );
  }
}

class dataChart extends StatelessWidget {
  const dataChart({super.key});

  @override
  Widget build(BuildContext context) {
    A10 device = ModalRoute.of(context)!.settings.arguments as A10;
    DeviceLogDataState centerDataProv =
        context.watch<DeviceLogDataProvider>().state;

    return SfCartesianChart(
      primaryYAxis: NumericAxis(
          maximum: device.tempHigh + 10,
          interval: 5,
          minimum: device.tempLow - 10,
          plotBands: <PlotBand>[
            PlotBand(
              horizontalTextAlignment: TextAnchor.end,
              shouldRenderAboveSeries: false,
              text: '${device.tempLow}°C',
              textStyle: TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
              isVisible: true,
              start: device.tempLow,
              end: device.tempLow,
              borderWidth: 2,
              borderColor: Colors.red,
            ),
            PlotBand(
              horizontalTextAlignment: TextAnchor.end,
              shouldRenderAboveSeries: false,
              text: '${device.tempHigh}°C',
              textStyle: TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
              isVisible: true,
              start: device.tempHigh,
              end: device.tempHigh,
              borderWidth: 2,
              borderColor: Colors.red,
            )
          ]),
      primaryXAxis: DateTimeAxis(
          // dateFormat: DateFormat.Hm(),
          dateFormat: DateFormat("MM-dd HH:mm"),
          labelRotation: 2,
          maximumLabels: 5,
          // Set name for x axis in order to use it in the callback event.
          name: 'primaryXAxis',
          intervalType: DateTimeIntervalType.hours,
          majorGridLines: MajorGridLines(width: 1)),
      legend: Legend(isVisible: false),
      // Enable tooltip
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <LineSeries<LogData, DateTime>>[
        LineSeries<LogData, DateTime>(
          // Bind data source
          dataSource: centerDataProv.deviceLogDataInfo.logDatas,
          xValueMapper: (LogData logData, _) => logData.dateTime,
          yValueMapper: (LogData logData, _) => logData.temp,
          name: '온도 데이터',
        )
      ],
    );
  }
}

class logInformation extends StatefulWidget {
  const logInformation({super.key});

  @override
  State<logInformation> createState() => _logInformationState();
}

class _logInformationState extends State<logInformation> {
  late A10 device = ModalRoute.of(context)!.settings.arguments as A10;
  late DateTime startDateTime = device.startTime.toLocal();
  late DateTime endDateTime = device.timeStamp.toLocal();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) async {
    //     // device = ModalRoute.of(context)!.settings.arguments as A10;
    //     startDateTime = device.startTime;
    //     endDateTime = device.timeStamp;
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    DeviceReportState centerReportState =
        context.watch<DeviceReportProvider>().state;
    DeviceLogDataState centerDataProv =
        context.watch<DeviceLogDataProvider>().state;

    return centerDataProv.deviceLogDataStatus == DeviceLogDataStatus.submitting
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 254, 246, 255),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 211, 210, 205),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 254, 246, 255),
                                borderRadius: BorderRadius.circular(10),
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
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue,
                                              Colors.red
                                            ], // 바깥쪽 테두리 색상 (그라디언트)
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 254, 246, 255),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white70,
                                                  offset: Offset(-8, -8),
                                                  blurRadius: 16,
                                                  spreadRadius: 2,
                                                ),
                                                BoxShadow(
                                                  color: Colors
                                                      .black26, // 아래쪽 어두운 그림자
                                                  offset: Offset(8, 8),
                                                  blurRadius: 16,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Text(
                                                        'Serial No',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: graphSubtitle(
                                                            context),
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      '${device.deNumber}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          graphContent(context),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: double.infinity, // 조금 더 두껍게
                                      width: 1,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFDDDDDD), // 살짝 어두운 배경색
                                        borderRadius: BorderRadius.circular(1),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white, // 위쪽 하이라이트 효과
                                            offset: Offset(-1, -1),
                                            blurRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Colors.black
                                                .withOpacity(0.3), // 아래쪽 그림자
                                            offset: Offset(1, 1),
                                            blurRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'startTime',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: graphSubtitle(
                                                            context),
                                                      ).tr(),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  startDateTime,
                                                              firstDate: DateTime
                                                                      .now()
                                                                  .subtract(
                                                                      Duration(
                                                                          days:
                                                                              30)),
                                                              lastDate: DateTime
                                                                  .now(),
                                                            ).then(
                                                              (DateTime?
                                                                  startDate) {
                                                                if (startDate !=
                                                                    null) {
                                                                  startDateTime =
                                                                      startDate;
                                                                }
                                                              },
                                                            );

                                                            await showTimePicker(
                                                              context: context,
                                                              initialTime: TimeOfDay(
                                                                  hour:
                                                                      startDateTime
                                                                          .hour,
                                                                  minute:
                                                                      startDateTime
                                                                          .minute),
                                                            ).then(
                                                              (TimeOfDay?
                                                                  startTime) {
                                                                if (startTime !=
                                                                    null) {
                                                                  final newStartTime = DateTime(
                                                                      startDateTime
                                                                          .year,
                                                                      startDateTime
                                                                          .month,
                                                                      startDateTime
                                                                          .day,
                                                                      startTime
                                                                          .hour,
                                                                      startTime
                                                                          .minute);

                                                                  startDateTime =
                                                                      newStartTime;
                                                                }
                                                                setState(() {});
                                                              },
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  side: BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          38,
                                                                          94,
                                                                          176),
                                                                      width:
                                                                          1), // 테두리 색상과 두께
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10), // 모서리 둥글기 조절
                                                                  )),
                                                          child: Text(
                                                            DateFormat(
                                                                    "MM-dd HH:mm")
                                                                .format(
                                                                    startDateTime),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        38,
                                                                        94,
                                                                        176)),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 1, // 조금 더 두껍게
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Color(
                                                    0xFFDDDDDD), // 살짝 어두운 배경색
                                                borderRadius:
                                                    BorderRadius.circular(1),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors
                                                        .white, // 위쪽 하이라이트 효과
                                                    offset: Offset(-1, -1),
                                                    blurRadius: 1,
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(
                                                            0.3), // 아래쪽 그림자
                                                    offset: Offset(1, 1),
                                                    blurRadius: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          'endTime',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: graphSubtitle(
                                                              context),
                                                        ).tr()),
                                                    Expanded(
                                                      flex: 1,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                endDateTime,
                                                            firstDate: DateTime
                                                                    .now()
                                                                .subtract(
                                                                    Duration(
                                                                        days:
                                                                            30)),
                                                            lastDate:
                                                                DateTime.now(),
                                                          ).then(
                                                            (DateTime?
                                                                endDate) {
                                                              if (endDate !=
                                                                  null) {
                                                                endDateTime =
                                                                    endDate;
                                                              }
                                                            },
                                                          );

                                                          await showTimePicker(
                                                            context: context,
                                                            initialTime:
                                                                TimeOfDay(
                                                                    hour: 22,
                                                                    minute: 10),
                                                          ).then(
                                                            (TimeOfDay?
                                                                endDate) {
                                                              if (endDate !=
                                                                  null) {
                                                                final newEndTime = DateTime(
                                                                    endDateTime
                                                                        .year,
                                                                    endDateTime
                                                                        .month,
                                                                    endDateTime
                                                                        .day,
                                                                    endDate
                                                                        .hour,
                                                                    endDate
                                                                        .minute);

                                                                endDateTime =
                                                                    newEndTime;
                                                              }
                                                              setState(() {});
                                                            },
                                                          );
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                side: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            38,
                                                                            94,
                                                                            176),
                                                                    width:
                                                                        1), // 테두리 색상과 두께
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10), // 모서리 둥글기 조절
                                                                )),
                                                        child: Text(
                                                          DateFormat(
                                                                  "MM-dd HH:mm")
                                                              .format(
                                                                  endDateTime),
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      38,
                                                                      94,
                                                                      176)),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      Expanded(
                          flex: 1,
                          child: centerReportState.tempHigh == -999
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'noData',
                                      style: TextStyle(
                                        color: Colors.red[600],
                                      ),
                                    ).tr(),
                                    Text(
                                      'timeCheckMsg',
                                      style: TextStyle(
                                        color: Colors.red[600],
                                      ),
                                    ).tr(),
                                  ],
                                ))
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(255, 211, 210, 205),
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color:
                                            Color.fromARGB(255, 254, 246, 255),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Image(
                                                    image: AssetImage(
                                                        'assets/images/temp_ic.png'),
                                                    fit: BoxFit.contain,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                Container(
                                                  height: 1, // 조금 더 두껍게
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Color(
                                                        0xFFDDDDDD), // 살짝 어두운 배경색
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .white, // 위쪽 하이라이트 효과
                                                        offset: Offset(-1, -1),
                                                        blurRadius: 1,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.3), // 아래쪽 그림자
                                                        offset: Offset(1, 1),
                                                        blurRadius: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Max: ${centerReportState.tempHigh}°C',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 194, 46, 46),
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Min: ${centerReportState.tempLow}°C',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 63, 100, 228),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: double.infinity, // 조금 더 두껍게
                                            width: 1,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                  0xFFDDDDDD), // 살짝 어두운 배경색
                                              borderRadius:
                                                  BorderRadius.circular(1),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors
                                                      .white, // 위쪽 하이라이트 효과
                                                  offset: Offset(-1, -1),
                                                  blurRadius: 1,
                                                ),
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(
                                                          0.3), // 아래쪽 그림자
                                                  offset: Offset(1, 1),
                                                  blurRadius: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Image(
                                                    image: AssetImage(
                                                        'assets/images/ic_humidity.png'),
                                                    fit: BoxFit.contain,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                Container(
                                                  height: 1, // 조금 더 두껍게
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Color(
                                                        0xFFDDDDDD), // 살짝 어두운 배경색
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .white, // 위쪽 하이라이트 효과
                                                        offset: Offset(-1, -1),
                                                        blurRadius: 1,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(
                                                                0.3), // 아래쪽 그림자
                                                        offset: Offset(1, 1),
                                                        blurRadius: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Max: ${centerReportState.humHigh}%',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 63, 100, 228),
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Min: ${centerReportState.humLow}%',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 63, 100, 228),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            child: ElevatedButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 38, 94, 176),
                                    textStyle: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                onPressed: () {
                                  final selectedCenterInfo = context
                                      .read<CenterListProvider>()
                                      .state
                                      .loginInfo;

                                  try {
                                    A10 newDevice = device.copyWith(
                                        startTime: startDateTime.toUtc(),
                                        timeStamp: endDateTime.toUtc());

                                    context
                                        .read<DeviceLogDataProvider>()
                                        .getDeviceLogData(
                                            device: newDevice,
                                            token: selectedCenterInfo.token,
                                            company:
                                                selectedCenterInfo.company);
                                  } on CustomError catch (e) {
                                    errorDialog(context, e.toString());
                                  }
                                },
                                child: Text('select').tr()),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Color.fromARGB(255, 31, 103, 60),
                                  textStyle: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  A10 device = ModalRoute.of(context)!
                                      .settings
                                      .arguments as A10;
                                  List<LogData> logDatas = context
                                      .read<DeviceLogDataProvider>()
                                      .state
                                      .deviceLogDataInfo
                                      .logDatas;

                                  var excel = ex.Excel.createExcel();
                                  ex.Sheet sheetObject = excel['Result'];
                                  excel.delete('Sheet1');

                                  sheetObject.appendRow([
                                    ex.TextCellValue('No.'),
                                    ex.TextCellValue('Temp'),
                                    ex.TextCellValue('DateTime')
                                  ]);
                                  for (int i = 0; i < logDatas.length; i++) {
                                    sheetObject.appendRow([
                                      ex.TextCellValue((i + 1).toString()),
                                      ex.TextCellValue(
                                          logDatas[i].temp.toString()),
                                      ex.TextCellValue(logDatas[i]
                                          .dateTime
                                          .toLocal()
                                          .toString())
                                    ]);
                                  }
                                  var fileBytes = excel.save();
                                  final dir =
                                      await getExternalStorageDirectory();

                                  // print("dir $dir");
                                  String filepath = dir!.path;
                                  String now = DateFormat('yyyyMMddHHmmss')
                                      .format(DateTime.now().toLocal());
                                  File f = File(
                                      '$filepath/${device.deNumber}Excel_$now.xlsx');
                                  f.writeAsBytesSync(fileBytes!);

                                  Share.shareXFiles([XFile(f.path)],
                                      text: 'Excel');
                                },
                                child: Text('excel').tr()),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          );
  }
}

class OptiloInfo extends StatelessWidget {
  const OptiloInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
