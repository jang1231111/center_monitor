import 'package:center_monitor/constants/style.dart';
import 'package:center_monitor/models/device/device_list_info.dart';
import 'package:center_monitor/models/device/device_logdata_info.dart';
import 'package:center_monitor/providers/device_data/device_data_provider.dart';
import 'package:center_monitor/providers/device_data/device_data_state.dart';
import 'package:center_monitor/providers/device_report/device_report_provider.dart';
import 'package:center_monitor/providers/device_report/device_report_state.dart';
import 'package:center_monitor/providers/login_number/login_number_provider.dart';
import 'package:center_monitor/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailPage extends StatelessWidget {
  static const String routeName = '/detail';
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 240, 240, 246),
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
                        color: Color.fromARGB(255, 38, 94, 176),
                        fontSize: 15.0),
                  ),
                  dataChart(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '온도 데이터 상세 정보',
                    style: TextStyle(
                        color: Color.fromARGB(255, 38, 94, 176),
                        fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(flex: 3, child: logInformation()),
                  SizedBox(
                    child: Divider(height: 5),
                    height: 20,
                  ),
                  Expanded(flex: 1, child: OptiloInfo()),
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
        Text(
          '상세 정보',
          style: TextStyle(fontSize: 25.0),
        ),
        Text(
          '${device.deName}',
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
    CenterDataState centerDataProv = context.watch<DeviceDataProvider>().state;

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
          dataSource: centerDataProv.centerDataInfo.logDatas,
          xValueMapper: (LogData logData, _) => logData.dateTime,
          yValueMapper: (LogData logData, _) => double.parse(logData.temp),
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
  late DateTime startDateTime = device.timeStamp;
  // late DateTime endDateTime = device.endTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        // device = ModalRoute.of(context)!.settings.arguments as A10;
        startDateTime = device.timeStamp;
        // endDateTime = device.endTime;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DeviceReportState centerReportState =
        context.watch<DeviceReportProvider>().state;
    CenterDataState centerDataProv = context.watch<DeviceDataProvider>().state;

    return centerDataProv.centerDataStatus == DeviceDataStatus.submitting
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Serial No',
                                  textAlign: TextAlign.center,
                                  style: subTitle(context),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  '${device.deNumber}',
                                  textAlign: TextAlign.center,
                                  style: subTitle(context),
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                '시작 시간',
                                textAlign: TextAlign.center,
                                style: subTitle(context),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await showDatePicker(
                                        context: context,
                                        initialDate: startDateTime,
                                        firstDate: DateTime.now()
                                            .subtract(Duration(days: 30)),
                                        lastDate: DateTime.now(),
                                      ).then(
                                        (DateTime? startDate) {
                                          if (startDate != null) {
                                            startDateTime = startDate;
                                          }
                                        },
                                      );

                                      await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                            hour: startDateTime.hour,
                                            minute: startDateTime.minute),
                                      ).then(
                                        (TimeOfDay? startTime) {
                                          if (startTime != null) {
                                            final newStartTime = DateTime(
                                                startDateTime.year,
                                                startDateTime.month,
                                                startDateTime.day,
                                                startTime.hour,
                                                startTime.minute);

                                            startDateTime = newStartTime;
                                          }
                                          setState(() {});
                                        },
                                      );
                                    },
                                    child: Text(
                                      DateFormat("MM월 dd일 HH:mm")
                                          .format(startDateTime),
                                      textAlign: TextAlign.center,
                                      style: subTitle(context),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  '종료 시간',
                                  textAlign: TextAlign.center,
                                  style: subTitle(context),
                                )),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  // child: 
                                  // ElevatedButton(
                                  //   onPressed: () async {
                                  //     await showDatePicker(
                                  //       context: context,
                                  //       // initialDate: endDateTime,
                                  //       firstDate: DateTime.now()
                                  //           .subtract(Duration(days: 30)),
                                  //       lastDate: DateTime.now(),
                                  //     ).then(
                                  //       (DateTime? endDate) {
                                  //         // if (endDate != null) {
                                  //         //   endDateTime = endDate;
                                  //         // }
                                  //       },
                                  //     );

                                  //     await showTimePicker(
                                  //       context: context,
                                  //       initialTime:
                                  //           TimeOfDay(hour: 22, minute: 10),
                                  //     ).then(
                                  //       (TimeOfDay? endDate) {
                                  //         if (endDate != null) {
                                  //           // final newEndTime = DateTime(
                                  //           //     endDateTime.year,
                                  //           //     endDateTime.month,
                                  //           //     endDateTime.day,
                                  //           //     endDate.hour,
                                  //           //     endDate.minute);

                                  //           // endDateTime = newEndTime;
                                  //         }
                                  //         setState(() {});
                                  //       },
                                  //     );
                                  //   },
                                  //   // child: 
                                  //   // Text(
                                  //     // DateFormat("MM월 dd일 HH:mm")
                                  //     //     .format(endDateTime),
                                  //   //   textAlign: TextAlign.center,
                                  //   //   style: subTitle(context),
                                  //   // ),
                                  // ),
                                ),
                                ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: centerReportState.tempHigh == -999
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '데이터가 없습니다.',
                                      style: TextStyle(
                                        color: Colors.red[600],
                                      ),
                                    ),
                                    Text(
                                      '시간 범위를 확인해주세요.',
                                      style: TextStyle(
                                        color: Colors.red[600],
                                      ),
                                    ),
                                  ],
                                ))
                              : Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                '최고 온도',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                '${centerReportState.tempHigh}°C',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                '최저 온도',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                '${centerReportState.tempLow}°C',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                '최고 습도',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                '${centerReportState.humHigh}%',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                '최저 습도',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                '${centerReportState.humLow}%',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 38, 94, 176),
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onPressed: () {
                        // A10 newDevice = device.copyWith(
                        //     startTime: startDateTime, endTime: endDateTime);

                        String _loginNumber = context
                            .read<LoginNumberProvider>()
                            .state
                            .phoneNumber;
                        try {
                          // context.read<DeviceDataProvider>().getCenterData(
                          //     device: newDevice, loginNumber: _loginNumber);
                        } catch (e) {
                          errorDialog(context, e.toString());
                        }
                      },
                      child: Text('조 회')),
                ),
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
    );
  }
}
