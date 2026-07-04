import 'package:flutter/material.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/pages/add_transaction_page.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';

class RecentTransactionsCard extends StatelessWidget {
  final List<TransactionEntity> transactions;
  final String currencyCode;
  final VoidCallback? onSeeAll;

  const RecentTransactionsCard({
    super.key,
    required this.transactions,
    required this.currencyCode,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Activity',
                      style: text.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  if (onSeeAll != null)
                    TextButton(
                      onPressed: onSeeAll,
                      child: const Text('See all'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            if (transactions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No activity yet',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              for (final t in transactions)
                TransactionTile(
                  transaction: t,
                  currencyCode: currencyCode,
                  onTap: () => AddTransactionPage.show(context, initial: t),
                ),
          ],
        ),
      ),
    );
  }
}
