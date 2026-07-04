import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../transactions/domain/entities/transaction_enums.dart';
import '../../../transactions/presentation/utils/category_visuals.dart';
import '../../domain/entities/dashboard_summary.dart';

class CategoryBreakdownCard extends StatelessWidget {
  final List<CategorySpend> breakdown;
  final String currencyCode;

  const CategoryBreakdownCard({
    super.key,
    required this.breakdown,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final top = breakdown.take(5).toList();
    final total = breakdown.fold<double>(0, (sum, e) => sum + e.amount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top Categories',
                style: text.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('This month',
                style: text.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            if (top.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text('No spending this month yet',
                      style: TextStyle(color: scheme.onSurfaceVariant)),
                ),
              )
            else
              for (final item in top) ...[
                _CategoryRow(
                  category: item.category,
                  amount: item.amount,
                  ratio: total <= 0 ? 0 : item.amount / total,
                  currencyCode: currencyCode,
                ),
                if (item != top.last) const SizedBox(height: 14),
              ],
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final TransactionCategory category;
  final double amount;
  final double ratio;
  final String currencyCode;

  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.ratio,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: category.color.withValues(alpha: 0.15),
          child: Icon(category.icon, size: 18, color: category.color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category.label,
                      style: text.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text(Formatters.currency(amount, code: currencyCode),
                      style: text.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6,
                  backgroundColor: scheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(category.color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
