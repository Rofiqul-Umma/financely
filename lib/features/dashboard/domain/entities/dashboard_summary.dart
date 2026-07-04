import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_enums.dart';

class MonthlyBucket extends Equatable {
  final DateTime month;
  final double expense;
  final double income;

  const MonthlyBucket({
    required this.month,
    required this.expense,
    required this.income,
  });

  @override
  List<Object?> get props => [month, expense, income];
}

class CategorySpend extends Equatable {
  final TransactionCategory category;
  final double amount;

  const CategorySpend({required this.category, required this.amount});

  @override
  List<Object?> get props => [category, amount];
}

class DashboardSummary extends Equatable {
  final double totalBalance;
  final double monthIncome;
  final double monthExpense;
  final List<MonthlyBucket> monthlyBuckets;
  final List<CategorySpend> categoryBreakdown;
  final List<TransactionEntity> recent;

  const DashboardSummary({
    required this.totalBalance,
    required this.monthIncome,
    required this.monthExpense,
    required this.monthlyBuckets,
    required this.categoryBreakdown,
    required this.recent,
  });

  const DashboardSummary.empty()
      : totalBalance = 0,
        monthIncome = 0,
        monthExpense = 0,
        monthlyBuckets = const [],
        categoryBreakdown = const [],
        recent = const [];

  double get maxMonthlyExpense => monthlyBuckets.isEmpty
      ? 0
      : monthlyBuckets
          .map((b) => b.expense)
          .reduce((a, b) => a > b ? a : b);

  @override
  List<Object?> get props => [
        totalBalance,
        monthIncome,
        monthExpense,
        monthlyBuckets,
        categoryBreakdown,
        recent,
      ];
}
