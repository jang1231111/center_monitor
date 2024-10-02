import 'package:center_monitor/pages/center_plan_page.dart';
import 'package:center_monitor/pages/detail_page.dart';
import 'package:center_monitor/pages/main_page.dart';
import 'package:center_monitor/pages/signin_page.dart';
import 'package:center_monitor/pages/splash_page.dart';
import 'package:center_monitor/providers/device_data/device_data_provider.dart';
import 'package:center_monitor/providers/device_filter/device_filter_provider.dart';
import 'package:center_monitor/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/providers/device_report/device_report_provider.dart';
import 'package:center_monitor/providers/filtered_device/filtered_device_provider.dart';
import 'package:center_monitor/providers/login_number/login_number_provider.dart';
import 'package:center_monitor/repositories/center_data_repositories.dart';
import 'package:center_monitor/repositories/center_list_repositories.dart';
import 'package:center_monitor/serivices/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MultiProvider(
      providers: [
        Provider<CenterListRepositories>(
          create: (context) => CenterListRepositories(
            apiServices: ApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        Provider<CenterDataRepostiories>(
          create: (context) => CenterDataRepostiories(
            apiServices: ApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        ChangeNotifierProvider<LoginNumberProvider>(
          create: (context) => LoginNumberProvider(),
        ),
        ChangeNotifierProvider<DeviceListProvider>(
          create: (context) => DeviceListProvider(
            centerListRepositories: context.read<CenterListRepositories>(),
          ),
        ),
        ChangeNotifierProvider<DeviceDataProvider>(
          create: (context) => DeviceDataProvider(
            centerDataRepositories: context.read<CenterDataRepostiories>(),
          ),
        ),
        ChangeNotifierProvider<DeviceFilterProvider>(
          create: (context) => DeviceFilterProvider(),
        ),
        ProxyProvider<DeviceDataProvider, DeviceReportProvider>(
          update: (BuildContext context, DeviceDataProvider centerDataProvider,
                  DeviceReportProvider? _) =>
              DeviceReportProvider(centerDataProvider: centerDataProvider),
        ),
        ProxyProvider2<DeviceListProvider, DeviceFilterProvider,
            FilteredDeviceProvider>(
          update: (
            BuildContext context,
            DeviceListProvider centerListProvider,
            DeviceFilterProvider centerFilterProvider,
            FilteredDeviceProvider? _,
          ) =>
              FilteredDeviceProvider(
            centerListProvider: centerListProvider,
            centerFilterProvider: centerFilterProvider,
          ),
        )
      ],
      child: MaterialApp(
        title: 'Center_Monitoring',
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        routes: {
          SigninPage.routeName: (context) => SigninPage(),
          MainPage.routeName: (context) => MainPage(),
          DetailPage.routeName: (context) => DetailPage(),
          CenterPlanPage.routeName: (context) => CenterPlanPage(),
        },
      ),
    );
  }
}
