import 'package:center_monitor/pages/center_plan_page.dart';
import 'package:center_monitor/pages/detail_page.dart';
import 'package:center_monitor/pages/main_page.dart';
import 'package:center_monitor/pages/signin_page.dart';
import 'package:center_monitor/pages/splash_page.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/providers/device_log_data/device_log_data_provider.dart';
import 'package:center_monitor/providers/device_filter/device_filter_provider.dart';
import 'package:center_monitor/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/providers/device_report/device_report_provider.dart';
import 'package:center_monitor/providers/filtered_device/filtered_device_provider.dart';
import 'package:center_monitor/providers/login_number/login_number_provider.dart';
import 'package:center_monitor/repositories/center_list_repositories.dart';
import 'package:center_monitor/repositories/device_data_repositories.dart';
import 'package:center_monitor/repositories/device_list_repositories.dart';
import 'package:center_monitor/serivices/api_services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  WakelockPlus.enable();

  runApp(
    EasyLocalization(
      child: const MyApp(),
      supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MultiProvider(
      providers: [
        Provider<CenterListRepositories>(
          create: (context) => CenterListRepositories(
            apiServices: ApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        Provider<DeviceListRepositories>(
          create: (context) => DeviceListRepositories(
            apiServices: ApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        Provider<DeviceDataRepostiories>(
          create: (context) => DeviceDataRepostiories(
            apiServices: ApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        ChangeNotifierProvider<LoginNumberProvider>(
          create: (context) => LoginNumberProvider(),
        ),
        ChangeNotifierProvider<CenterListProvider>(
          create: (context) => CenterListProvider(
              centerListRepositories: context.read<CenterListRepositories>()),
        ),
        ChangeNotifierProvider<DeviceListProvider>(
          create: (context) => DeviceListProvider(
            centerListRepositories: context.read<DeviceListRepositories>(),
          ),
        ),
        ChangeNotifierProvider<DeviceLogDataProvider>(
          create: (context) => DeviceLogDataProvider(
            centerDataRepositories: context.read<DeviceDataRepostiories>(),
          ),
        ),
        ChangeNotifierProvider<DeviceFilterProvider>(
          create: (context) => DeviceFilterProvider(),
        ),
        ProxyProvider<DeviceLogDataProvider, DeviceReportProvider>(
          update: (BuildContext context,
                  DeviceLogDataProvider centerDataProvider,
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
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
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
