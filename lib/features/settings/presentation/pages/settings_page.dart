import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/currencies.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../security/presentation/cubit/app_lock_cubit.dart';
import '../../../security/presentation/pages/set_passcode_page.dart';
import '../../domain/services/sync_service.dart';
import '../../domain/usecases/export_transactions_csv.dart';
import '../../domain/usecases/seed_dummy_data.dart';
import '../cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cubit = context.watch<SettingsCubit>();
    final settings = cubit.state;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionHeader(l.appearance, Icons.palette_outlined),
                _SettingsGroup(
                  children: [
                    _ThemeModeTile(
                      mode: settings.themeMode,
                      onChanged: cubit.setThemeMode,
                    ),
                    const Divider(),
                    SwitchListTile(
                      secondary: const Icon(Icons.auto_awesome_rounded),
                      title: Text(l.dynamicColor),
                      subtitle: Text(l.dynamicColorSubtitle),
                      value: settings.useDynamicColor,
                      onChanged: cubit.setUseDynamicColor,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.font_download_outlined),
                      title: Text(l.font),
                      subtitle: Text(
                        fontByFamily(settings.fontFamily).name,
                        style: TextStyle(fontFamily: settings.fontFamily),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _pickFont(context, cubit),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _AccentPicker(
                  selected: settings.seedColor,
                  usingDynamic: settings.useDynamicColor,
                  onSelected: (color) {
                    // Choosing an accent implies the user wants a custom
                    // color, so switch off dynamic theming to apply it.
                    if (settings.useDynamicColor) {
                      cubit.setUseDynamicColor(false);
                    }
                    cubit.setSeedColor(color);
                  },
                ),
                const SizedBox(height: 24),
                _SectionHeader(
                  l.budgetAndCurrency,
                  Icons.account_balance_wallet_outlined,
                ),
                _SettingsGroup(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.savings_outlined),
                      title: Text(l.monthlyBudget),
                      subtitle: Text(
                        Formatters.currency(
                          settings.monthlyBudget,
                          code: settings.currencyCode,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _editBudget(context, cubit),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.attach_money_rounded),
                      title: Text(l.currency),
                      subtitle: Text(
                        currencyByCode(settings.currencyCode).name,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _pickCurrency(context, cubit),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.translate_rounded),
                      title: Text(l.language),
                      subtitle: Text(_languageName(l, settings.languageCode)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _pickLanguage(context, cubit),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SectionHeader(l.security, Icons.lock_outline_rounded),
                const _SecuritySection(),
                const SizedBox(height: 24),
                _SectionHeader(l.dataAndSync, Icons.cloud_sync_outlined),
                _SettingsGroup(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.file_download_outlined),
                      title: Text(l.exportToCsv),
                      subtitle: Text(l.exportSubtitle),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _exportCsv(context),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.cloud_upload_outlined),
                      title: Text(l.cloudSync),
                      subtitle: Text(l.cloudSyncSubtitle),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _runSync(context),
                    ),
                    if (kDebugMode) ...[
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.science_outlined),
                        title: const Text('Seed dummy data'),
                        subtitle:
                            const Text('Insert ~6 months of demo transactions'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _seedDummyData(context),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),
                _SectionHeader(l.about, Icons.info_outline_rounded),
                _SettingsGroup(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.receipt_long_rounded),
                      title: Text(l.appTitle),
                      subtitle: Text(l.version),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _languageName(AppLocalizations l, String code) =>
      code == 'id' ? l.languageIndonesian : l.languageEnglish;

  Future<void> _editBudget(BuildContext context, SettingsCubit cubit) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(
      text: cubit.state.monthlyBudget.toStringAsFixed(0),
    );
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.monthlyBudget),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            prefixText: '${currencyByCode(cubit.state.currencyCode).symbol} ',
            labelText: l.amount,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, double.tryParse(controller.text) ?? 0),
            child: Text(l.save),
          ),
        ],
      ),
    );
    if (result != null && result > 0) {
      await cubit.setMonthlyBudget(result);
    }
  }

  Future<void> _pickCurrency(BuildContext context, SettingsCubit cubit) async {
    final code = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final currency in kSupportedCurrencies)
              ListTile(
                leading: Text(
                  currency.symbol,
                  style: const TextStyle(fontSize: 20),
                ),
                title: Text(currency.name),
                subtitle: Text(currency.code),
                trailing: currency.code == cubit.state.currencyCode
                    ? Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, currency.code),
              ),
          ],
        ),
      ),
    );
    if (code == null || code == cubit.state.currencyCode) return;
    if (!context.mounted) return;

    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(l.currencyUpdating)),
          ],
        ),
      ),
    );
    final ok = await cubit.setCurrency(code);
    if (context.mounted) Navigator.of(context).pop();
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l.currencyUpdateFailed)));
    }
  }

  Future<void> _pickFont(BuildContext context, SettingsCubit cubit) async {
    final family = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final font in kAppFonts)
              ListTile(
                title: Text(
                  font.name,
                  style: TextStyle(fontFamily: font.family, fontSize: 18),
                ),
                trailing: font.family == cubit.state.fontFamily
                    ? Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, font.family),
              ),
          ],
        ),
      ),
    );
    if (family != null) await cubit.setFontFamily(family);
  }

  Future<void> _pickLanguage(BuildContext context, SettingsCubit cubit) async {
    final l = AppLocalizations.of(context);
    final options = {'en': l.languageEnglish, 'id': l.languageIndonesian};
    final code = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final entry in options.entries)
              ListTile(
                leading: const Icon(Icons.translate_rounded),
                title: Text(entry.value),
                trailing: entry.key == cubit.state.languageCode
                    ? Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(context, entry.key),
              ),
          ],
        ),
      ),
    );
    if (code != null) await cubit.setLanguage(code);
  }

  Future<void> _exportCsv(BuildContext context) async {
    final choice = await showModalBottomSheet<_ExportChoice>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        final l = AppLocalizations.of(sheetContext);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(
                  l.exportRangeTitle,
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.all_inclusive_rounded),
                title: Text(l.exportAllTime),
                subtitle: Text(l.exportAllTimeSubtitle),
                onTap: () =>
                    Navigator.pop(sheetContext, _ExportChoice.allTime),
              ),
              ListTile(
                leading: const Icon(Icons.date_range_rounded),
                title: Text(l.exportCustomRange),
                subtitle: Text(l.exportCustomRangeSubtitle),
                onTap: () => Navigator.pop(sheetContext, _ExportChoice.custom),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
    if (choice == null || !context.mounted) return;

    DateTime? start;
    DateTime? end;
    if (choice == _ExportChoice.custom) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: today,
      );
      if (picked == null || !context.mounted) return;
      start = DateTime(picked.start.year, picked.start.month, picked.start.day);
      end = DateTime(
          picked.end.year, picked.end.month, picked.end.day, 23, 59, 59, 999);
    }

    final messenger = ScaffoldMessenger.of(context);
    final unavailable = AppLocalizations.of(context).exportUnavailable;
    try {
      final csv = await sl<ExportTransactionsCsv>()(start: start, end: end);
      final suffix = start != null && end != null
          ? '_${_fileDate(start)}_${_fileDate(end)}'
          : '';
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              Uint8List.fromList(utf8.encode(csv)),
              mimeType: 'text/csv',
              name: 'financely_export$suffix.csv',
            ),
          ],
          subject: 'Financely transactions',
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text(unavailable)),
      );
    }
  }

  String _fileDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';

  Future<void> _seedDummyData(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final count = await sl<SeedDummyData>()();
      if (context.mounted) Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(content: Text('Inserted $count demo transactions')),
      );
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(content: Text('Seed failed: $e')));
    }
  }

  Future<void> _runSync(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    final result = await sl<SyncService>().sync();
    if (context.mounted) Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text(result.message)));
  }
}

enum _ExportChoice { allTime, custom }

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.primary),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(children: children),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeModeTile({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.brightness_6_outlined),
              const SizedBox(width: 16),
              Text(l.theme, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              // Drop icons on narrow widths so the labels stay on one line.
              final showIcons = constraints.maxWidth >= 360;
              return SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(l.themeSystem, maxLines: 1),
                    icon: showIcons
                        ? const Icon(Icons.brightness_auto_rounded)
                        : null,
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text(l.themeLight, maxLines: 1),
                    icon: showIcons
                        ? const Icon(Icons.light_mode_rounded)
                        : null,
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text(l.themeDark, maxLines: 1),
                    icon: showIcons
                        ? const Icon(Icons.dark_mode_rounded)
                        : null,
                  ),
                ],
                selected: {mode},
                onSelectionChanged: (s) => onChanged(s.first),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection();

  Future<void> _togglePasscode(BuildContext context, bool value) async {
    final l = AppLocalizations.of(context);
    final cubit = context.read<AppLockCubit>();
    if (value) {
      await SetPasscodePage.show(context);
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.removePasscodeQuestion),
          content: Text(l.removePasscodeContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.remove),
            ),
          ],
        ),
      );
      if (confirmed == true) await cubit.disablePasscode();
    }
  }

  Future<void> _toggleBiometric(BuildContext context, bool value) async {
    final messenger = ScaffoldMessenger.of(context);
    final failed = AppLocalizations.of(context).couldNotEnableBiometric;
    final ok = await context.read<AppLockCubit>().setBiometricEnabled(value);
    if (!ok && value) {
      messenger.showSnackBar(
        SnackBar(content: Text(failed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocBuilder<AppLockCubit, AppLockState>(
      builder: (context, state) {
        return _SettingsGroup(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.pin_outlined),
              title: Text(l.appPasscode),
              subtitle: Text(l.appPasscodeSubtitle),
              value: state.passcodeEnabled,
              onChanged: (v) => _togglePasscode(context, v),
            ),
            if (state.passcodeEnabled) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.password_rounded),
                title: Text(l.changePasscode),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => SetPasscodePage.show(context, isChange: true),
              ),
              if (state.biometricAvailable) ...[
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded),
                  title: Text(l.biometricUnlock),
                  subtitle: Text(l.biometricSubtitle),
                  value: state.biometricEnabled,
                  onChanged: (v) => _toggleBiometric(context, v),
                ),
              ],
            ],
          ],
        );
      },
    );
  }
}

class _AccentPicker extends StatelessWidget {
  final Color selected;
  final bool usingDynamic;
  final ValueChanged<Color> onSelected;

  const _AccentPicker({
    required this.selected,
    required this.usingDynamic,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).accentColor,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              usingDynamic
                  ? AppLocalizations.of(context).accentDynamicHint
                  : AppLocalizations.of(context).accentPickHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final color in AppPalette.seeds)
                  _Swatch(
                    color: color,
                    selected:
                        !usingDynamic &&
                        color.toARGB32() == selected.toARGB32(),
                    onTap: () => onSelected(color),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.onSurface
                : Colors.transparent,
            width: 3,
          ),
        ),
        child: selected
            ? const Icon(Icons.check_rounded, color: Colors.white)
            : null,
      ),
    );
  }
}
