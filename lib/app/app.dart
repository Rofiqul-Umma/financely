import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../features/settings/domain/entities/app_settings.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import 'app_shell.dart';

class MaterialLedgerApp extends StatelessWidget {
  const MaterialLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, AppSettings>(
      builder: (context, settings) {
        return DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            final useDynamic = settings.useDynamicColor;
            return MaterialApp(
              title: 'Material Ledger',
              debugShowCheckedModeBanner: false,
              themeMode: settings.themeMode,
              theme: AppTheme.from(
                seed: settings.seedColor,
                brightness: Brightness.light,
                dynamicScheme: useDynamic ? lightDynamic : null,
              ),
              darkTheme: AppTheme.from(
                seed: settings.seedColor,
                brightness: Brightness.dark,
                dynamicScheme: useDynamic ? darkDynamic : null,
              ),
              home: const AppShell(),
            );
          },
        );
      },
    );
  }
}
