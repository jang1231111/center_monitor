import 'package:center_monitor/pages/center_plan_page.dart';
import 'package:center_monitor/pages/detail_page.dart';
import 'package:center_monitor/pages/main_page.dart';
import 'package:center_monitor/pages/signin_page.dart';
import 'package:center_monitor/pages/splash_page.dart';
import 'package:center_monitor/providers/center_data/center_data_provider.dart';
import 'package:center_monitor/providers/center_filter/center_filter_provider.dart';
import 'package:center_monitor/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/providers/center_report/center_report_provider.dart';
import 'package:center_monitor/providers/filtered_center/filtered_center_provider.dart';
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
        ChangeNotifierProvider<CenterListProvider>(
          create: (context) => CenterListProvider(
            centerListRepositories: context.read<CenterListRepositories>(),
          ),
        ),
        ChangeNotifierProvider<CenterDataProvider>(
          create: (context) => CenterDataProvider(
            centerDataRepositories: context.read<CenterDataRepostiories>(),
          ),
        ),
        ChangeNotifierProvider<CenterFilterProvider>(
          create: (context) => CenterFilterProvider(),
        ),
        ProxyProvider<CenterDataProvider, CenterReportProvider>(
          update: (BuildContext context, CenterDataProvider centerDataProvider,
                  CenterReportProvider? _) =>
              CenterReportProvider(centerDataProvider: centerDataProvider),
        ),
        ProxyProvider2<CenterListProvider, CenterFilterProvider,
            FilteredCenterProvider>(
          update: (
            BuildContext context,
            CenterListProvider centerListProvider,
            CenterFilterProvider centerFilterProvider,
            FilteredCenterProvider? _,
          ) =>
              FilteredCenterProvider(
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
