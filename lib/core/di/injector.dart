import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/accounts/data/datasources/account_local_datasource.dart';
import '../../features/accounts/data/repositories/account_repository_impl.dart';
import '../../features/accounts/domain/repositories/account_repository.dart';
import '../../features/accounts/domain/usecases/watch_accounts.dart';
import '../../features/accounts/presentation/cubit/accounts_cubit.dart';
import '../../features/currency/data/exchange_rate_remote_datasource.dart';
import '../../features/currency/data/exchange_rate_repository_impl.dart';
import '../../features/currency/domain/repositories/exchange_rate_repository.dart';
import '../../features/currency/domain/usecases/change_currency.dart';
import '../../features/dashboard/domain/usecases/build_dashboard_summary.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/security/data/app_reset_repository_impl.dart';
import '../../features/security/data/passcode_repository_impl.dart';
import '../../features/security/domain/repositories/app_reset_repository.dart';
import '../../features/security/domain/repositories/passcode_repository.dart';
import '../../features/security/presentation/cubit/app_lock_cubit.dart';
import '../../features/settings/data/services/stub_sync_service.dart';
import '../../features/settings/data/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/services/sync_service.dart';
import '../../features/settings/domain/usecases/export_transactions_csv.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/transaction_usecases.dart';
import '../../features/transactions/presentation/bloc/transactions_bloc.dart';
import '../database/app_database.dart';

final GetIt sl = GetIt.instance;

/// Wires the object graph. Call once before running the app.
Future<void> configureDependencies() async {
  // External / core.
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerSingleton<AppDatabase>(AppDatabase())
    ..registerLazySingleton(() => http.Client());

  // Currency exchange.
  sl
    ..registerLazySingleton(() => ExchangeRateRemoteDataSource(sl()))
    ..registerLazySingleton<ExchangeRateRepository>(
        () => ExchangeRateRepositoryImpl(sl(), sl()))
    ..registerLazySingleton(() => ChangeCurrency(sl(), sl(), sl()));

  // Transactions feature.
  sl
    ..registerLazySingleton(() => TransactionLocalDataSource(sl()))
    ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepositoryImpl(sl()))
    ..registerLazySingleton(() => WatchTransactions(sl()))
    ..registerLazySingleton(() => AddTransaction(sl()))
    ..registerLazySingleton(() => DeleteTransaction(sl()))
    ..registerLazySingleton(
      () => TransactionsBloc(
        watchTransactions: sl(),
        addTransaction: sl(),
        deleteTransaction: sl(),
      ),
    );

  // Accounts feature.
  sl
    ..registerLazySingleton(() => AccountLocalDataSource(sl()))
    ..registerLazySingleton<AccountRepository>(
        () => AccountRepositoryImpl(sl()))
    ..registerLazySingleton(() => WatchAccounts(sl()))
    ..registerLazySingleton(() => AccountsCubit(sl()));

  // Dashboard feature.
  sl
    ..registerLazySingleton(() => const BuildDashboardSummary())
    ..registerFactory(
      () => DashboardBloc(
        watchTransactions: sl(),
        watchAccounts: sl(),
        buildSummary: sl(),
      ),
    );

  // Settings feature.
  sl
    ..registerLazySingleton<SettingsRepository>(
        () => SettingsRepositoryImpl(sl()))
    ..registerLazySingleton<SyncService>(StubSyncService.new)
    ..registerLazySingleton(() => ExportTransactionsCsv(sl(), sl()))
    ..registerLazySingleton(() => SettingsCubit(sl(), sl()));

  // Security feature.
  sl
    ..registerLazySingleton<PasscodeRepository>(
        () => PasscodeRepositoryImpl(sl()))
    ..registerLazySingleton<AppResetRepository>(
        () => AppResetRepositoryImpl(sl()))
    ..registerLazySingleton(() => AppLockCubit(sl(), sl()));
}
