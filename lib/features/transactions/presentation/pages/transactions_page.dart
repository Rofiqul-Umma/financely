import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formatters.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transactions_bloc.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_page.dart';

/// Full chronological transaction history, grouped by day.
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
        if (state.transactions.isEmpty) {
          return const _EmptyHistory();
        }

        final groups = _groupByDay(state.transactions);
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 120),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                  child: Text(
                    Formatters.relativeDate(group.day),
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
                    onDismissed: (_) => context
                        .read<TransactionsBloc>()
                        .add(TransactionDeleted(t.id)),
                    child: TransactionTile(
                      transaction: t,
                      currencyCode: currencyCode,
                      onTap: () =>
                          AddTransactionPage.show(context, initial: t),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_rounded,
              size: 64, color: scheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text('No transactions yet',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Tap + to log your first one',
              style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
