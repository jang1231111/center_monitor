import 'package:center_monitor/data/datasources/remote/remote_data_source.dart';
import 'package:center_monitor/data/repositories/version_repository_impl.dart';
import 'package:center_monitor/domain/usecases/check_version_update_usecase.dart';
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
import 'package:center_monitor/presentation/providers/theme/theme_provider.dart';
import 'package:center_monitor/presentation/providers/user/user_provider.dart';
import 'package:center_monitor/presentation/providers/version/version_provider.dart';
import 'package:center_monitor/data/repositories/center_list_repositories.dart';
import 'package:center_monitor/data/repositories/device_data_repositories.dart';
import 'package:center_monitor/data/repositories/device_list_repositories.dart';
import 'package:center_monitor/data/datasources/remote/api_services.dart';
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
    MultiProvider(
      providers: [
        // ✅ 2. RemoteDataSource 등록 (ApiService 필요)
        Provider<RemoteDataSource>(
            create: (context) =>
                RemoteDataSource(ApiServices(httpClient: http.Client()))),
        // ✅ 3. Repository 등록 (RemoteDataSource 필요)
        ///** 지금 impl로 설정 수정해야함 abstract class로
        Provider<VersionRepositoryImpl>(
            create: (context) =>
                VersionRepositoryImpl(context.read<RemoteDataSource>())),
        // ✅ 4. UseCase 등록 (Repository 필요)
        Provider<CheckVersionUpdateUseCase>(
            create: (context) => CheckVersionUpdateUseCase(
                context.read<VersionRepositoryImpl>())),
        // ✅ 5. ChangeNotifierProvider 등록 (Repository 필요)
        ChangeNotifierProvider<VersionProvider>(
            create: (context) => VersionProvider(
                getVersionUseCase: context.read<CheckVersionUpdateUseCase>())),
        ////
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
