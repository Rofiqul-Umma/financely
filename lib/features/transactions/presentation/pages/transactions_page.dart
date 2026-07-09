import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_labels.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transactions_bloc.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_page.dart';

/// Full chronological transaction history, grouped by day, with a date-range
/// filter.
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyCode =
        context.select((SettingsCubit c) => c.state.currencyCode);

    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        if (state.status == TransactionsStatus.loading &&
            state.transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // Nothing logged at all: nudge the user to add their first entry.
        if (state.transactions.isEmpty) {
          return const _EmptyHistory();
        }

        final visible = state.filteredTransactions;
        return Column(
          children: [
            _FilterBar(start: state.filterStart, end: state.filterEnd),
            Expanded(
              child: visible.isEmpty
                  ? const _NoResults()
                  : _buildList(context, visible, currencyCode),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    List<TransactionEntity> transactions,
    String currencyCode,
  ) {
    final groups = _groupByDay(transactions);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 120),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
              child: Text(
                localizedRelativeDate(context, group.day),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            for (final t in group.items)
              Dismissible(
                key: ValueKey(t.id),
                direction: DismissDirection.endToStart,
                background: _deleteBackground(context),
                onDismissed: (_) => _deleteWithUndo(context, t),
                child: TransactionTile(
                  transaction: t,
                  currencyCode: currencyCode,
                  onTap: () => AddTransactionPage.show(context, initial: t),
                ),
              ),
          ],
        );
      },
    );
  }

  void _deleteWithUndo(BuildContext context, TransactionEntity t) {
    final l = AppLocalizations.of(context);
    final bloc = context.read<TransactionsBloc>();
    bloc.add(TransactionDeleted(t.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(l.transactionDeleted),
        action: SnackBarAction(
          label: l.undo,
          onPressed: () => bloc.add(TransactionAdded(t)),
        ),
      ));
  }

  Widget _deleteBackground(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.delete_rounded, color: scheme.onErrorContainer),
    );
  }

  List<_DayGroup> _groupByDay(List<TransactionEntity> transactions) {
    final map = <DateTime, List<TransactionEntity>>{};
    for (final t in transactions) {
      final key = DateTime(t.date.year, t.date.month, t.date.day);
      map.putIfAbsent(key, () => []).add(t);
    }
    final groups = map.entries
        .map((e) => _DayGroup(e.key, e.value))
        .toList()
      ..sort((a, b) => b.day.compareTo(a.day));
    return groups;
  }
}

/// Horizontally scrollable bar with a custom range picker and quick presets.
class _FilterBar extends StatelessWidget {
  final DateTime? start;
  final DateTime? end;
  const _FilterBar({this.start, this.end});

  bool get _active => start != null || end != null;

  Future<void> _pickRange(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = (start != null && end != null)
        ? DateTimeRange(start: start!, end: end!)
        : null;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: today,
      initialDateRange: initial,
    );
    if (picked != null && context.mounted) {
      context.read<TransactionsBloc>().add(
            TransactionsFilterChanged(
              start: _dayStart(picked.start),
              end: _dayStart(picked.end),
            ),
          );
    }
  }

  void _preset(BuildContext context, DateTime start, DateTime end) {
    context
        .read<TransactionsBloc>()
        .add(TransactionsFilterChanged(start: start, end: end));
  }

  void _clear(BuildContext context) {
    context
        .read<TransactionsBloc>()
        .add(const TransactionsFilterChanged());
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final rangeLabel =
        _active ? _formatRange(locale, start, end) : l.filterAllTime;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          ActionChip(
            avatar: const Icon(Icons.date_range_rounded, size: 18),
            label: Text(rangeLabel),
            tooltip: l.filterDateRange,
            onPressed: () => _pickRange(context),
          ),
          const SizedBox(width: 8),
          ActionChip(
            label: Text(l.filterThisMonth),
            onPressed: () =>
                _preset(context, DateTime(now.year, now.month, 1), today),
          ),
          const SizedBox(width: 8),
          ActionChip(
            label: Text(l.filterLast30Days),
            onPressed: () => _preset(
              context,
              today.subtract(const Duration(days: 29)),
              today,
            ),
          ),
          if (_active) ...[
            const SizedBox(width: 8),
            ActionChip(
              avatar: const Icon(Icons.close_rounded, size: 18),
              label: Text(l.filterClear),
              onPressed: () => _clear(context),
            ),
          ],
        ],
      ),
    );
  }
}

DateTime _dayStart(DateTime d) => DateTime(d.year, d.month, d.day);

String _formatRange(String locale, DateTime? start, DateTime? end) {
  final fmt = DateFormat.yMMMd(locale);
  if (start != null && end != null) {
    return start == end
        ? fmt.format(start)
        : '${fmt.format(start)} – ${fmt.format(end)}';
  }
  if (start != null) return '≥ ${fmt.format(start)}';
  if (end != null) return '≤ ${fmt.format(end)}';
  return '';
}

class _DayGroup {
  final DateTime day;
  final List<TransactionEntity> items;
  const _DayGroup(this.day, this.items);
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_rounded,
              size: 64, color: scheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(l.noTransactionsYet,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l.tapToLogFirst,
              style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

/// Shown when transactions exist but none fall inside the active date filter.
class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_alt_off_rounded,
              size: 64, color: scheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l.filterNoResults,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => context
                .read<TransactionsBloc>()
                .add(const TransactionsFilterChanged()),
            icon: const Icon(Icons.close_rounded),
            label: Text(l.filterClear),
          ),
        ],
      ),
    );
  }
}
