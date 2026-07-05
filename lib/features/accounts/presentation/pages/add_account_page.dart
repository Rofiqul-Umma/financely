import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/currencies.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/account.dart';
import '../cubit/accounts_cubit.dart';
import '../utils/account_visuals.dart';

class AddAccountPage extends StatefulWidget {
  /// When non-null the page opens in edit mode, pre-filled with this account.
  final AccountEntity? initial;

  const AddAccountPage({super.key, this.initial});

  static Future<void> show(BuildContext context, {AccountEntity? initial}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AddAccountPage(initial: initial),
      ),
    );
  }

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _openingController = TextEditingController();

  int _iconId = 0;
  int _colorValue = kAccountColors.first.toARGB32();

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _nameController.text = initial.name;
      _openingController.text = _trimZeros(initial.openingBalance);
      _iconId = initial.iconId;
      _colorValue = initial.colorValue;
    }
  }

  static String _trimZeros(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _openingController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final l = AppLocalizations.of(context);
    final opening =
        double.tryParse(_openingController.text.replaceAll(',', '.')) ?? 0;
    final account = AccountEntity(
      id: widget.initial?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      colorValue: _colorValue,
      iconId: _iconId,
      openingBalance: opening,
    );
    context.read<AccountsCubit>().save(account);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(_isEditing ? l.accountUpdated : l.accountAdded),
      ));
  }

  Future<void> _confirmDelete() async {
    final initial = widget.initial;
    if (initial == null) return;
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteAccountQuestion),
        content: Text(l.accountWillBeRemoved(initial.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    context.read<AccountsCubit>().delete(initial.id);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.accountDeleted)));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final currencyCode =
        context.select((SettingsCubit c) => c.state.currencyCode);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(_isEditing ? l.editAccount : l.newAccountTitle),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: l.delete,
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l.accountName,
                hintText: l.accountNameHint,
                prefixIcon: const Icon(Icons.badge_outlined),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.enterName : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _openingController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,-]')),
              ],
              decoration: InputDecoration(
                labelText: l.openingBalance,
                prefixText: '${currencyByCode(currencyCode).symbol} ',
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              ),
            ),
            const SizedBox(height: 24),
            _SectionLabel(l.icon),
            const SizedBox(height: 12),
            _IconPicker(
              selected: _iconId,
              color: Color(_colorValue),
              onSelected: (id) => setState(() => _iconId = id),
            ),
            const SizedBox(height: 24),
            _SectionLabel(l.color),
            const SizedBox(height: 12),
            _ColorPicker(
              selectedValue: _colorValue,
              onSelected: (value) => setState(() => _colorValue = value),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: Text(_isEditing ? l.saveChanges : l.createAccount),
          style: FilledButton.styleFrom(
            backgroundColor: scheme.primary,
            minimumSize: const Size.fromHeight(56),
          ),
        ),
      ),
    );
  }
}

class _IconPicker extends StatelessWidget {
  final int selected;
  final Color color;
  final ValueChanged<int> onSelected;

  const _IconPicker({
    required this.selected,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (var i = 0; i < kAccountIcons.length; i++)
          GestureDetector(
            onTap: () => onSelected(i),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: selected == i
                    ? color.withValues(alpha: 0.16)
                    : scheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected == i ? color : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                kAccountIcons[i],
                color: selected == i ? color : scheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int> onSelected;

  const _ColorPicker({required this.selectedValue, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        for (final color in kAccountColors)
          GestureDetector(
            onTap: () => onSelected(color.toARGB32()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color.toARGB32() == selectedValue
                      ? scheme.onSurface
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: color.toARGB32() == selectedValue
                  ? const Icon(Icons.check_rounded, color: Colors.white)
                  : null,
            ),
          ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
