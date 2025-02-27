import 'package:center_monitor/core/di/service_locator.dart';
import 'package:center_monitor/presentation/pages/center_plan_page.dart';
import 'package:center_monitor/presentation/pages/detail_page.dart';
import 'package:center_monitor/presentation/pages/main_page.dart';
import 'package:center_monitor/presentation/pages/my_page.dart';
import 'package:center_monitor/presentation/pages/setting_page.dart';
import 'package:center_monitor/presentation/pages/navigation_page.dart';
import 'package:center_monitor/presentation/pages/signin_page.dart';
import 'package:center_monitor/presentation/pages/signup_page.dart';
import 'package:center_monitor/presentation/pages/splash_page.dart';
import 'package:center_monitor/presentation/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/presentation/providers/device_log_data/device_log_data_provider.dart';
import 'package:center_monitor/presentation/providers/device_filter/device_filter_provider.dart';
import 'package:center_monitor/presentation/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/presentation/providers/device_report/device_report_provider.dart';
import 'package:center_monitor/presentation/providers/center_search/center_search_provider.dart';
import 'package:center_monitor/presentation/providers/filtered_device/filtered_device_provider.dart';
import 'package:center_monitor/presentation/providers/login_number/login_number_provider.dart';
import 'package:center_monitor/presentation/providers/notice/notice_provider.dart';
import 'package:center_monitor/presentation/providers/theme/theme_provider.dart';
import 'package:center_monitor/presentation/providers/version/version_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  WakelockPlus.enable();

  setupLocator(); // 🔹 의존성 주입 설정

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<VersionProvider>()),
        ChangeNotifierProvider(create: (_) => sl<NoticeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ThemeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LoginNumberProvider>()),
        ChangeNotifierProvider(create: (_) => sl<CenterListProvider>()),
        ChangeNotifierProvider(create: (_) => sl<DeviceListProvider>()),
        ChangeNotifierProvider(create: (_) => sl<DeviceLogDataProvider>()),
        ChangeNotifierProvider(create: (_) => sl<DeviceFilterProvider>()),
        ChangeNotifierProvider(create: (_) => sl<CenterSearchProvider>()),

        // ProxyProvider (다른 Provider 의존성 사용)
        ProxyProvider<DeviceLogDataProvider, DeviceReportProvider>(
          update: (context, centerDataProvider, _) =>
              DeviceReportProvider(centerDataProvider: centerDataProvider),
        ),
        ProxyProvider3<DeviceListProvider, DeviceFilterProvider,
            CenterSearchProvider, FilteredDeviceProvider>(
          update: (context, centerListProvider, centerFilterProvider,
                  deviceSearchProvider, _) =>
              FilteredDeviceProvider(
            centerListProvider: centerListProvider,
            centerFilterProvider: centerFilterProvider,
            centerSearchProvider: deviceSearchProvider,
          ),
        ),
      ],
      child: EasyLocalization(
        child: const MyApp(),
        supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      darkTheme: ThemeData.dark(),
      themeMode: context.watch<ThemeProvider>().themeMode,
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
    );
  }
}
