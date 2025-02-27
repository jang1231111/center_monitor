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
import 'package:intl/intl.dart';
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
                    'temperatureGraph',
                    style: TextStyle(
                        color: Color.fromARGB(255, 38, 94, 176),
                        fontSize: 15.0),
                  ),
                  dataChart(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'temperatureDataDetail',
                    style: TextStyle(
                        color: Color.fromARGB(255, 38, 94, 176),
                        fontSize: 15.0),
                  ).tr(),
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
          'detailInfo',
          style: TextStyle(fontSize: 25.0),
        ).tr(),
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
                                'startTime',
                                textAlign: TextAlign.center,
                                style: subTitle(context),
                              ).tr(),
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
                                      DateFormat("MM-dd HH:mm")
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
                                  'endTime',
                                  textAlign: TextAlign.center,
                                  style: subTitle(context),
                                ).tr()),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await showDatePicker(
                                      context: context,
                                      initialDate: endDateTime,
                                      firstDate: DateTime.now()
                                          .subtract(Duration(days: 30)),
                                      lastDate: DateTime.now(),
                                    ).then(
                                      (DateTime? endDate) {
                                        if (endDate != null) {
                                          endDateTime = endDate;
                                        }
                                      },
                                    );

                                    await showTimePicker(
                                      context: context,
                                      initialTime:
                                          TimeOfDay(hour: 22, minute: 10),
                                    ).then(
                                      (TimeOfDay? endDate) {
                                        if (endDate != null) {
                                          final newEndTime = DateTime(
                                              endDateTime.year,
                                              endDateTime.month,
                                              endDateTime.day,
                                              endDate.hour,
                                              endDate.minute);

                                          endDateTime = newEndTime;
                                        }
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child: Text(
                                    DateFormat("MM-dd HH:mm")
                                        .format(endDateTime),
                                    textAlign: TextAlign.center,
                                    style: subTitle(context),
                                  ),
                                ),
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
                              : Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                'maxTemp',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              ).tr()),
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
                                                'minTemp',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              ).tr()),
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
                                                'maxHum',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              ).tr()),
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
                                                'minHum',
                                                textAlign: TextAlign.center,
                                                style: subTitle(context),
                                              ).tr()),
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
              Expanded(
                flex: 1,
                child: Padding(
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
                          //   startTime: DateTime.utc(device.timeStamp.year,
                          //       device.timeStamp.month, device.timeStamp.day),
                          // );

                          // A10 newDevice = device.copyWith(
                          //     startTime: startDateTime, endTime: endDateTime);

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
                                    company: selectedCenterInfo.company);
                          } on CustomError catch (e) {
                            errorDialog(context, e.toString());
                          }
                        },
                        child: Text('select').tr()),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 31, 103, 60),
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        onPressed: () async {
                          A10 device =
                              ModalRoute.of(context)!.settings.arguments as A10;
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
                              ex.TextCellValue(logDatas[i].temp.toString()),
                              ex.TextCellValue(
                                  logDatas[i].dateTime.toLocal().toString())
                            ]);
                          }
                          var fileBytes = excel.save();
                          final dir = await getExternalStorageDirectory();

                          // print("dir $dir");
                          String filepath = dir!.path;
                          String now = DateFormat('yyyyMMddHHmmss')
                              .format(DateTime.now().toLocal());
                          File f = File(
                              '$filepath/${device.deNumber}Excel_$now.xlsx');
                          f.writeAsBytesSync(fileBytes!);

                          Share.shareXFiles([XFile(f.path)], text: 'Excel');
                        },
                        child: Text('excel').tr()),
                  ),
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
