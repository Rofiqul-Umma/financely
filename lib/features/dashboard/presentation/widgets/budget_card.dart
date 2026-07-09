import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';

class BudgetCard extends StatelessWidget {
  final double spent;
  final double budget;
  final String currencyCode;

  const BudgetCard({
    super.key,
    required this.spent,
    required this.budget,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context);
    final ratio = budget <= 0 ? 0.0 : (spent / budget).clamp(0.0, 1.0);
    final overBudget = spent > budget && budget > 0;
    final remaining = budget - spent;

    final progressColor = overBudget
        ? scheme.error
        : ratio > 0.8
            ? const Color(0xFFEF6C00)
            : scheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l.budgetMonthlyBudget,
                    style: text.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text('${(ratio * 100).round()}%',
                    style: text.titleMedium?.copyWith(
                      color: progressColor,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 12,
                backgroundColor: scheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(progressColor),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    l.budgetSpent(
                        Formatters.currency(spent, code: currencyCode)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    overBudget
                        ? l.budgetOver(Formatters.currency(remaining.abs(),
                            code: currencyCode))
                        : l.budgetLeft(
                            Formatters.currency(remaining, code: currencyCode)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: text.bodyMedium?.copyWith(
                      color: overBudget ? scheme.error : scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
