import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../features/security/presentation/cubit/app_lock_cubit.dart';
import '../features/security/presentation/pages/lock_screen.dart';
import '../features/settings/domain/entities/app_settings.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import 'app_shell.dart';

/// Overlays the lock screen above the whole navigator when the app is locked,
/// and re-locks whenever the app is sent to the background.
class AppLockGate extends StatefulWidget {
  final Widget child;
  const AppLockGate({super.key, required this.child});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      context.read<AppLockCubit>().lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked = context.select((AppLockCubit c) => c.state.isLocked);
    return Stack(
      children: [
        widget.child,
        if (locked) const Positioned.fill(child: LockScreen()),
      ],
    );
  }
}

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
              title: 'Financely',
              debugShowCheckedModeBanner: false,
              locale: Locale(settings.languageCode),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              themeMode: settings.themeMode,
              theme: AppTheme.from(
                seed: settings.seedColor,
                brightness: Brightness.light,
                fontFamily: settings.fontFamily,
                dynamicScheme: useDynamic ? lightDynamic : null,
              ),
              darkTheme: AppTheme.from(
                seed: settings.seedColor,
                brightness: Brightness.dark,
                fontFamily: settings.fontFamily,
                dynamicScheme: useDynamic ? darkDynamic : null,
              ),
              builder: (context, child) =>
                  AppLockGate(child: child ?? const SizedBox.shrink()),
              home: const AppShell(),
            );
          },
        );
      },
    );
  }
}
