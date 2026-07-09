import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/balance_card.dart';
import '../widgets/budget_card.dart';
import '../widgets/category_breakdown_card.dart';
import '../widgets/expense_bar_chart.dart';
import '../widgets/recent_transactions_card.dart';

class DashboardPage extends StatelessWidget {
  final VoidCallback? onSeeAllTransactions;

  const DashboardPage({super.key, this.onSeeAllTransactions});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>().state;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading ||
            state.status == DashboardStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        final summary = state.summary;

        final balance = BalanceCard(
          totalBalance: summary.totalBalance,
          monthIncome: summary.monthIncome,
          monthExpense: summary.monthExpense,
          currencyCode: settings.currencyCode,
          obscure: settings.hideBalances,
        );
        final budget = BudgetCard(
          spent: summary.monthExpense,
          budget: settings.monthlyBudget,
          currencyCode: settings.currencyCode,
        );
        final chart = ExpenseBarChart(
          buckets: summary.monthlyBuckets,
          maxExpense: summary.maxMonthlyExpense,
          currencyCode: settings.currencyCode,
        );
        final categories = CategoryBreakdownCard(
          breakdown: summary.categoryBreakdown,
          currencyCode: settings.currencyCode,
        );
        final recent = RecentTransactionsCard(
          transactions: summary.recent,
          currencyCode: settings.currencyCode,
          onSeeAll: onSeeAllTransactions,
        );

        final content = context.isExpandedOrLarger
            ? _WideLayout(
                balance: balance,
                budget: budget,
                chart: chart,
                categories: categories,
                recent: recent,
              )
            : _NarrowLayout(
                balance: balance,
                budget: budget,
                chart: chart,
                categories: categories,
                recent: recent,
              );

        return RefreshIndicator(
          onRefresh: () async => context
              .read<DashboardBloc>()
              .add(const DashboardSubscriptionRequested()),
          child: content,
        );
      },
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  final Widget balance;
  final Widget budget;
  final Widget chart;
  final Widget categories;
  final Widget recent;

  const _NarrowLayout({
    required this.balance,
    required this.budget,
    required this.chart,
    required this.categories,
    required this.recent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      children: [
        balance,
        const SizedBox(height: 16),
        budget,
        const SizedBox(height: 16),
        chart,
        const SizedBox(height: 16),
        categories,
        const SizedBox(height: 16),
        recent,
      ],
    );
  }
}

class _WideLayout extends StatelessWidget {
  final Widget balance;
  final Widget budget;
  final Widget chart;
  final Widget categories;
  final Widget recent;

  const _WideLayout({
    required this.balance,
    required this.budget,
    required this.chart,
    required this.categories,
    required this.recent,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  balance,
                  const SizedBox(height: 20),
                  chart,
                  const SizedBox(height: 20),
                  budget,
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  categories,
                  const SizedBox(height: 20),
                  recent,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
