import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/currencies.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/services/sync_service.dart';
import '../../domain/usecases/export_transactions_csv.dart';
import '../cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                const _SectionHeader('Appearance', Icons.palette_outlined),
                _SettingsGroup(
                  children: [
                    _ThemeModeTile(
                      mode: settings.themeMode,
                      onChanged: cubit.setThemeMode,
                    ),
                    const Divider(),
                    SwitchListTile(
                      secondary: const Icon(Icons.auto_awesome_rounded),
                      title: const Text('Dynamic color'),
                      subtitle: const Text(
                        'Use colors from your device wallpaper',
                      ),
                      value: settings.useDynamicColor,
                      onChanged: cubit.setUseDynamicColor,
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
                const _SectionHeader(
                  'Budget & Currency',
                  Icons.account_balance_wallet_outlined,
                ),
                _SettingsGroup(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.savings_outlined),
                      title: const Text('Monthly budget'),
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
                      title: const Text('Currency'),
                      subtitle: Text(
                        currencyByCode(settings.currencyCode).name,
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _pickCurrency(context, cubit),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionHeader('Data & Sync', Icons.cloud_sync_outlined),
                _SettingsGroup(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.file_download_outlined),
                      title: const Text('Export to CSV'),
                      subtitle: const Text('Share your transaction history'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _exportCsv(context),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.cloud_upload_outlined),
                      title: const Text('Cloud sync'),
                      subtitle: const Text('Back up to the cloud (demo)'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _runSync(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionHeader('About', Icons.info_outline_rounded),
                _SettingsGroup(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.receipt_long_rounded),
                      title: Text('Financely'),
                      subtitle: Text('Version 1.0.0'),
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

  Future<void> _editBudget(BuildContext context, SettingsCubit cubit) async {
    final controller = TextEditingController(
      text: cubit.state.monthlyBudget.toStringAsFixed(0),
    );
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Monthly budget'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            prefixText: '${currencyByCode(cubit.state.currencyCode).symbol} ',
            labelText: 'Amount',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, double.tryParse(controller.text) ?? 0),
            child: const Text('Save'),
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
    if (code != null) await cubit.setCurrency(code);
  }

  Future<void> _exportCsv(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final csv = await sl<ExportTransactionsCsv>()();
      final dir = await getTemporaryDirectory();
      final file = File(p.join(dir.path, 'financely_export.csv'));
      await file.writeAsString(csv);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'text/csv')],
          subject: 'Financely transactions',
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Export is unavailable on this device')),
      );
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.brightness_6_outlined),
              const SizedBox(width: 16),
              Text('Theme', style: Theme.of(context).textTheme.bodyLarge),
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
                    label: const Text('System', maxLines: 1),
                    icon: showIcons
                        ? const Icon(Icons.brightness_auto_rounded)
                        : null,
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: const Text('Light', maxLines: 1),
                    icon: showIcons
                        ? const Icon(Icons.light_mode_rounded)
                        : null,
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: const Text('Dark', maxLines: 1),
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
            Text('Accent color', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(
              usingDynamic
                  ? 'Pick a color to switch off dynamic theming'
                  : 'Pick your Material You brand color',
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
