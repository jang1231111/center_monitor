import 'package:center_monitor/data/datasources/remote/api_services.dart';
import 'package:center_monitor/data/datasources/remote/remote_data_source.dart';
import 'package:center_monitor/data/repositories/center/center_list_repositories.dart';
import 'package:center_monitor/data/repositories/device/device_data_repositories.dart';
import 'package:center_monitor/data/repositories/device/device_list_repositories.dart';
import 'package:center_monitor/data/repositories/notice/notice_repository_impl.dart';
import 'package:center_monitor/data/repositories/version/version_repository_impl.dart';
import 'package:center_monitor/domain/repositories/notice_repository.dart';
import 'package:center_monitor/domain/repositories/version_repository.dart';
import 'package:center_monitor/domain/usecases/notice/get_notice_usecase.dart';
import 'package:center_monitor/domain/usecases/version/check_version_update_usecase.dart';
import 'package:center_monitor/presentation/providers/center_list/center_list_provider.dart';
import 'package:center_monitor/presentation/providers/center_search/center_search_provider.dart';
import 'package:center_monitor/presentation/providers/device_filter/device_filter_provider.dart';
import 'package:center_monitor/presentation/providers/device_list/device_list_provider.dart';
import 'package:center_monitor/presentation/providers/device_log_data/device_log_data_provider.dart';
import 'package:center_monitor/presentation/providers/login_number/login_number_provider.dart';
import 'package:center_monitor/presentation/providers/notice/notice_provider.dart';
import 'package:center_monitor/presentation/providers/theme/theme_provider.dart';
import 'package:center_monitor/presentation/providers/version/version_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

void setupLocator() {
  // ✅ 공통 네트워크 서비스
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => ApiServices(httpClient: sl()));

  // ✅ Remote DataSource
  sl.registerLazySingleton(() => RemoteDataSource(sl<ApiServices>()));

  // ✅ Version 관련 DI
  sl.registerLazySingleton<VersionRepository>(
      () => VersionRepositoryImpl(sl<RemoteDataSource>()));
  sl.registerLazySingleton(
      () => CheckVersionUpdateUseCase(sl<VersionRepository>()));
  sl.registerFactory(() =>
      VersionProvider(getVersionUseCase: sl<CheckVersionUpdateUseCase>()));

  // ✅ Notice 관련 DI
  sl.registerLazySingleton<NoticeRepository>(
      () => NoticeRepositoryImpl(sl<RemoteDataSource>()));
  sl.registerLazySingleton(() => GetNoticeUsecase(sl<NoticeRepository>()));
  sl.registerFactory(
      () => NoticeProvider(getNoticeUsecase: sl<GetNoticeUsecase>()));

  // ✅ Center & Device 관련 DI
  sl.registerLazySingleton(() => CenterListRepositories(apiServices: sl()));
  sl.registerLazySingleton(() => DeviceListRepositories(apiServices: sl()));
  sl.registerLazySingleton(() => DeviceDataRepostiories(apiServices: sl()));

  // ✅ UI 관련 Provider
  sl.registerFactory(() => ThemeProvider());
  sl.registerFactory(() => LoginNumberProvider());
  sl.registerFactory(() => CenterListProvider(centerListRepositories: sl()));
  sl.registerFactory(() => DeviceListProvider(centerListRepositories: sl()));
  sl.registerFactory(() => DeviceLogDataProvider(centerDataRepositories: sl()));
  sl.registerFactory(() => DeviceFilterProvider());
  sl.registerFactory(() => CenterSearchProvider());
}
