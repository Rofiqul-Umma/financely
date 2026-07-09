import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';

const _kBalanceMask = '••••••';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double monthIncome;
  final double monthExpense;
  final String currencyCode;
  final bool obscure;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthIncome,
    required this.monthExpense,
    required this.currencyCode,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context);

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
          Row(
            children: [
              Expanded(
                child: Text(
                  l.balanceTotalBalance,
                  style: text.labelLarge?.copyWith(
                    color: scheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: obscure ? l.showBalance : l.hideBalance,
                onPressed: () =>
                    context.read<SettingsCubit>().toggleHideBalances(),
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: scheme.onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              obscure
                  ? _kBalanceMask
                  : Formatters.currency(totalBalance, code: currencyCode),
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
                  label: l.balanceIncome,
                  value: obscure
                      ? _kBalanceMask
                      : Formatters.currency(monthIncome, code: currencyCode),
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
                  label: l.balanceSpent,
                  value: obscure
                      ? _kBalanceMask
                      : Formatters.currency(monthExpense, code: currencyCode),
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
