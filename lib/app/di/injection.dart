import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/api_client.dart';
import '../../core/theme/app_theme.dart';
import '../../data/datasources/tcmb_remote_datasource.dart';
import '../../data/repositories/currency_repository_impl.dart';
import '../../domain/repositories/currency_repository.dart';

final GetIt getIt = GetIt.instance;

/// Bağımlılık enjeksiyonu kurulumu
Future<void> setupDependencies() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Theme Controller
  getIt.registerSingleton<ThemeController>(ThemeController());

  // Core
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data sources
  getIt.registerLazySingleton<TcmbRemoteDatasource>(
    () => TcmbRemoteDatasource(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<CurrencyRepository>(
    () =>
        CurrencyRepositoryImpl(remoteDatasource: getIt<TcmbRemoteDatasource>()),
  );
}
