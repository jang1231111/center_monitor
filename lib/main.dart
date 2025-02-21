import 'package:center_monitor/pages/center_plan_page.dart';
import 'package:center_monitor/pages/detail_page.dart';
import 'package:center_monitor/pages/main_page.dart';
import 'package:center_monitor/pages/my_page.dart';
import 'package:center_monitor/pages/setting_page.dart';
import 'package:center_monitor/pages/navigation_page.dart';
import 'package:center_monitor/pages/signin_page.dart';
import 'package:center_monitor/pages/signup_page.dart';
import 'package:center_monitor/pages/splash_page.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/providers/device_log_data/device_log_data_provider.dart';
import 'package:center_monitor/providers/device_filter/device_filter_provider.dart';
import 'package:center_monitor/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/providers/device_report/device_report_provider.dart';
import 'package:center_monitor/providers/center_search/center_search_provider.dart';
import 'package:center_monitor/providers/filtered_device/filtered_device_provider.dart';
import 'package:center_monitor/providers/login_number/login_number_provider.dart';
import 'package:center_monitor/providers/user/user_provider.dart';
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
        Provider<UserProvider>(
          create: (context) => UserProvider(),
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
        ChangeNotifierProvider<CenterSearchProvider>(
          create: (context) => CenterSearchProvider(),
        ),
        ProxyProvider<DeviceLogDataProvider, DeviceReportProvider>(
          update: (BuildContext context,
                  DeviceLogDataProvider centerDataProvider,
                  DeviceReportProvider? _) =>
              DeviceReportProvider(centerDataProvider: centerDataProvider),
        ),
        ProxyProvider3<DeviceListProvider, DeviceFilterProvider,
            CenterSearchProvider, FilteredDeviceProvider>(
          update: (
            BuildContext context,
            DeviceListProvider centerListProvider,
            DeviceFilterProvider centerFilterProvider,
            CenterSearchProvider deviceSearchProvider,
            FilteredDeviceProvider? _,
          ) =>
              FilteredDeviceProvider(
            centerListProvider: centerListProvider,
            centerFilterProvider: centerFilterProvider,
            centerSearchProvider: deviceSearchProvider,
          ),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.grey), // 기본 라벨 색상
            floatingLabelStyle: TextStyle(
              color: Color.fromARGB(255, 38, 94, 176),
            ), // 포커스 시 라벨 색상
          ),
        ),
        title: 'Center_Monitoring',
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        // home: MyPage(),
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        routes: {
          SigninPage.routeName: (context) => SigninPage(),
          NavigationPage.routeName: (context) => NavigationPage(),
          SettingPage.routeName: (context) => SettingPage(),
          MyPage.routeName: (context) => MyPage(),
          SignUpPage.routeName: (context) => SignUpPage(),
          MainPage.routeName: (context) => MainPage(),
          DetailPage.routeName: (context) => DetailPage(),
          CenterPlanPage.routeName: (context) => CenterPlanPage(),
        },
      ),
    );
  }
}
