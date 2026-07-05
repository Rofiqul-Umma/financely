import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/currencies.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_labels.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/cubit/accounts_cubit.dart';
import '../../../accounts/presentation/utils/account_visuals.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_enums.dart';
import '../bloc/transactions_bloc.dart';
import '../utils/category_visuals.dart';

class AddTransactionPage extends StatefulWidget {
  /// When non-null the page opens in edit mode, pre-filled with this record.
  final TransactionEntity? initial;

  const AddTransactionPage({super.key, this.initial});

  static Future<void> show(BuildContext context, {TransactionEntity? initial}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AddTransactionPage(initial: initial),
      ),
    );
  }

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _customLabelController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  TransactionCategory _category = TransactionCategory.food;
  PaymentMethod _paymentMethod = PaymentMethod.card;
  String? _accountId;
  String? _toAccountId;
  DateTime _date = DateTime.now();

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _titleController.text = initial.title;
      _amountController.text = _trimZeros(initial.amount);
      _noteController.text = initial.note ?? '';
      _customLabelController.text = initial.customLabel ?? '';
      _type = initial.type;
      _category = initial.category;
      _paymentMethod = initial.paymentMethod;
      _accountId = initial.accountId;
      _toAccountId = initial.toAccountId;
      _date = initial.date;
    }
  }

  static String _trimZeros(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _customLabelController.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionType type) {
    setState(() {
      _type = type;
      // Nudge the category to a sensible default for the new direction.
      if (!type.categories.contains(_category)) {
        _category = type.categories.first;
      }
      if (_category != TransactionCategory.other) {
        _customLabelController.clear();
      }
    });
  }

  /// Currently-selected source account, falling back to the first account.
  String? _resolveFrom(List<AccountEntity> accounts) =>
      _accountId ?? (accounts.isEmpty ? null : accounts.first.id);

  /// Currently-selected destination account (transfers only), defaulting to the
  /// first account that differs from the source.
  String? _resolveTo(List<AccountEntity> accounts, String? fromId) {
    if (_toAccountId != null) return _toAccountId;
    for (final a in accounts) {
      if (a.id != fromId) return a.id;
    }
    return null;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final accounts = context.read<AccountsCubit>().state.accounts;
    final fromId = _resolveFrom(accounts);
    final toId = _resolveTo(accounts, fromId);

    if (fromId == null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l.createAccountFirst)));
      return;
    }
    if (_type == TransactionType.transfer) {
      if (toId == null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l.addSecondAccountTransfer)));
        return;
      }
      if (fromId == toId) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text(l.chooseTwoDifferentAccounts)));
        return;
      }
    }

    final amount = double.parse(_amountController.text.replaceAll(',', '.'));
    final customLabel = _customLabelController.text.trim();
    final transaction = TransactionEntity(
      id: widget.initial?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      amount: amount,
      type: _type,
      category: _category,
      customLabel: _category == TransactionCategory.other && customLabel.isNotEmpty
          ? customLabel
          : null,
      paymentMethod: _paymentMethod,
      accountId: fromId,
      toAccountId: _type == TransactionType.transfer ? toId : null,
      date: _date,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _isEditing ? l.saveChangesQuestion : l.addTransactionQuestion,
        ),
        content: Text(
          _isEditing ? l.saveTransactionConfirm : l.addTransactionConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    context.read<TransactionsBloc>().add(TransactionAdded(transaction));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(_isEditing
              ? l.typeUpdated(_type.localizedLabel(l))
              : l.typeAdded(_type.localizedLabel(l))),
        ),
      );
  }

  Future<void> _confirmDelete() async {
    final initial = widget.initial;
    if (initial == null) return;
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteTransactionQuestion),
        content: Text(l.willBeRemovedPermanently(initial.title)),
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
    context.read<TransactionsBloc>().add(TransactionDeleted(initial.id));
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.transactionDeleted)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final currencyCode =
        context.select((SettingsCubit c) => c.state.currencyCode);
    final accounts = context.watch<AccountsCubit>().state.accounts;
    final fromId = _resolveFrom(accounts);
    final toId = _resolveTo(accounts, fromId);
    final isTransfer = _type == TransactionType.transfer;
    final categories = _type.categories;
    final customSuggestions = context
        .read<TransactionsBloc>()
        .state
        .transactions
        .map((t) => t.customLabel?.trim())
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(_isEditing ? l.editTransaction : l.addTransaction),
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
            _TypeToggle(type: _type, onChanged: _onTypeChanged),
            const SizedBox(height: 24),
            _AmountField(
              controller: _amountController,
              symbol: currencyByCode(currencyCode).symbol,
              isIncome: _type == TransactionType.income,
              autofocus: !_isEditing,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.description,
                hintText: l.descriptionHint,
                prefixIcon: const Icon(Icons.edit_note_rounded),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l.enterDescription : null,
            ),
            const SizedBox(height: 24),
            _SectionLabel(l.category),
            const SizedBox(height: 12),
            _CategoryGrid(
              categories: categories,
              selected: _category,
              onSelected: (c) => setState(() {
                _category = c;
                if (c != TransactionCategory.other) {
                  _customLabelController.clear();
                }
              }),
            ),
            if (_category == TransactionCategory.other) ...[
              const SizedBox(height: 12),
              _CustomCategoryField(
                controller: _customLabelController,
                suggestions: customSuggestions,
                onSuggestionTap: (label) =>
                    setState(() => _customLabelController.text = label),
              ),
            ],
            const SizedBox(height: 24),
            _SectionLabel(l.date),
            const SizedBox(height: 8),
            _DateTile(date: _date, onTap: _pickDate),
            const SizedBox(height: 24),
            _SectionLabel(l.paymentMethod),
            const SizedBox(height: 12),
            _PaymentSelector(
              selected: _paymentMethod,
              onChanged: (m) => setState(() => _paymentMethod = m),
            ),
            const SizedBox(height: 24),
            _SectionLabel(isTransfer ? l.fromAccount : l.account),
            const SizedBox(height: 12),
            _AccountSelector(
              accounts: accounts,
              selectedId: fromId,
              onSelected: (id) => setState(() {
                _accountId = id;
                if (id == _toAccountId) _toAccountId = null;
              }),
            ),
            if (isTransfer) ...[
              const SizedBox(height: 24),
              _SectionLabel(l.toAccount),
              const SizedBox(height: 12),
              _AccountSelector(
                accounts: accounts,
                selectedId: toId,
                disabledId: fromId,
                onSelected: (id) => setState(() => _toAccountId = id),
              ),
            ],
            const SizedBox(height: 24),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.noteOptional,
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
              ),
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
          label: Text(_isEditing ? l.saveChanges : l.saveTransaction),
          style: FilledButton.styleFrom(
            backgroundColor: scheme.primary,
            minimumSize: const Size.fromHeight(56),
          ),
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final TransactionType type;
  final ValueChanged<TransactionType> onChanged;

  const _TypeToggle({required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        // On narrow widths the icon + label pairs can't share one line, so
        // drop the icons and keep just the labels to avoid wrapping.
        final showIcons = constraints.maxWidth >= 360;
        return SegmentedButton<TransactionType>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: TransactionType.expense,
              label: Text(l.typeExpense, maxLines: 1),
              icon: showIcons ? const Icon(Icons.south_west_rounded) : null,
            ),
            ButtonSegment(
              value: TransactionType.income,
              label: Text(l.typeIncome, maxLines: 1),
              icon: showIcons ? const Icon(Icons.north_east_rounded) : null,
            ),
            ButtonSegment(
              value: TransactionType.transfer,
              label: Text(l.typeTransfer, maxLines: 1),
              icon: showIcons ? const Icon(Icons.swap_horiz_rounded) : null,
            ),
          ],
          selected: {type},
          onSelectionChanged: (s) => onChanged(s.first),
        );
      },
    );
  }
}

class _CustomCategoryField extends StatelessWidget {
  final TextEditingController controller;
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;

  const _CustomCategoryField({
    required this.controller,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l.customCategoryName,
            hintText: l.customCategoryHint,
            prefixIcon: const Icon(Icons.new_label_outlined),
          ),
        ),
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final suggestion in suggestions)
                ActionChip(
                  avatar: const Icon(Icons.history_rounded, size: 18),
                  label: Text(suggestion),
                  onPressed: () => onSuggestionTap(suggestion),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String symbol;
  final bool isIncome;
  final bool autofocus;

  const _AmountField({
    required this.controller,
    required this.symbol,
    required this.isIncome,
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isIncome ? const Color(0xFF2E7D32) : scheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            symbol,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: controller,
              autofocus: autofocus,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: '0.00',
                contentPadding: EdgeInsets.zero,
              ),
              validator: (v) {
                final l = AppLocalizations.of(context);
                if (v == null || v.trim().isEmpty) return l.enterAmount;
                final parsed = double.tryParse(v.replaceAll(',', '.'));
                if (parsed == null || parsed <= 0) return l.enterValidAmount;
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<TransactionCategory> categories;
  final TransactionCategory selected;
  final ValueChanged<TransactionCategory> onSelected;

  const _CategoryGrid({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final category in categories)
          _CategoryPill(
            category: category,
            selected: category == selected,
            scheme: scheme,
            onTap: () => onSelected(category),
          ),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final TransactionCategory category;
  final bool selected;
  final ColorScheme scheme;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.category,
    required this.selected,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? category.color.withValues(alpha: 0.16) : scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? category.color : Colors.transparent,
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 20, color: category.color),
              const SizedBox(width: 8),
              Text(
                category.localizedLabel(AppLocalizations.of(context)),
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? category.color : scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const _DateTile({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Icon(Icons.calendar_today_rounded, color: scheme.primary),
        title: Text(
          '${date.day}/${date.month}/${date.year}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.edit_calendar_outlined),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

class _PaymentSelector extends StatelessWidget {
  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  const _PaymentSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final showIcons = constraints.maxWidth >= 360;
        return SegmentedButton<PaymentMethod>(
          showSelectedIcon: false,
          segments: [
            for (final method in PaymentMethod.values)
              ButtonSegment(
                value: method,
                label: Text(method.localizedLabel(l), maxLines: 1),
                icon: showIcons ? Icon(method.icon) : null,
              ),
          ],
          selected: {selected},
          onSelectionChanged: (s) => onChanged(s.first),
        );
      },
    );
  }
}

class _AccountSelector extends StatelessWidget {
  final List<AccountEntity> accounts;
  final String? selectedId;

  /// When set, this account is shown greyed-out and cannot be picked (used to
  /// stop a transfer's destination matching its source).
  final String? disabledId;
  final ValueChanged<String> onSelected;

  const _AccountSelector({
    required this.accounts,
    required this.selectedId,
    this.disabledId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (accounts.isEmpty) {
      return Text(
        AppLocalizations.of(context).noAccountsAddFromTab,
        style: TextStyle(color: scheme.onSurfaceVariant),
      );
    }
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final account in accounts)
          _AccountChip(
            account: account,
            selected: account.id == selectedId,
            disabled: account.id == disabledId,
            onTap: () => onSelected(account.id),
          ),
      ],
    );
  }
}

class _AccountChip extends StatelessWidget {
  final AccountEntity account;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  const _AccountChip({
    required this.account,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = account.color;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Material(
        color: selected
            ? color.withValues(alpha: 0.16)
            : scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: disabled ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(account.icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  account.name,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? color : scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
