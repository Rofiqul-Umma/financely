import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'core/di/injector.dart';
import 'features/accounts/presentation/cubit/accounts_cubit.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/transactions/presentation/bloc/transactions_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  // Load persisted preferences.
  await sl<SettingsCubit>().load();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<SettingsCubit>()),
        BlocProvider.value(
          value: sl<TransactionsBloc>()
            ..add(const TransactionsSubscriptionRequested()),
        ),
        BlocProvider.value(
          value: sl<AccountsCubit>()..subscribe(),
        ),
        BlocProvider(
          create: (_) =>
              sl<DashboardBloc>()..add(const DashboardSubscriptionRequested()),
        ),
      ],
      child: const MaterialLedgerApp(),
    ),
  );
}
