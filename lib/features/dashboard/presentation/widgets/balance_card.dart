import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double monthIncome;
  final double monthExpense;
  final String currencyCode;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthIncome,
    required this.monthExpense,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, scheme.tertiary],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: text.labelLarge?.copyWith(
              color: scheme.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              Formatters.currency(totalBalance, code: currencyCode),
              maxLines: 1,
              style: text.displaySmall?.copyWith(
                color: scheme.onPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.south_west_rounded,
                  label: 'Income',
                  value: Formatters.currency(monthIncome, code: currencyCode),
                  onColor: scheme.onPrimary,
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: scheme.onPrimary.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _MiniStat(
                  icon: Icons.north_east_rounded,
                  label: 'Spent',
                  value: Formatters.currency(monthExpense, code: currencyCode),
                  onColor: scheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color onColor;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.onColor,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: onColor.withValues(alpha: 0.18),
            child: Icon(icon, size: 18, color: onColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: text.labelMedium
                        ?.copyWith(color: onColor.withValues(alpha: 0.85))),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: text.titleMedium
                        ?.copyWith(color: onColor, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
