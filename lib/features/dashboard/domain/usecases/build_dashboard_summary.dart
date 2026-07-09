import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/usecases/account_balance.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_enums.dart';
import '../entities/dashboard_summary.dart';

/// Pure aggregation of accounts and transactions into dashboard metrics.
class BuildDashboardSummary {
  const BuildDashboardSummary();

  static const int monthsShown = 6;

  DashboardSummary call(
    List<TransactionEntity> transactions,
    List<AccountEntity> accounts,
  ) {
    if (transactions.isEmpty && accounts.isEmpty) {
      return const DashboardSummary.empty();
    }

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    // Total balance is the sum of every account's current balance
    // (opening balance + its transactions), so it always includes the
    // opening balance of newly added accounts.
    final totalBalance = accounts.fold<double>(
      0,
      (sum, account) => sum + accountBalance(account, transactions),
    );
    var monthIncome = 0.0;
    var monthExpense = 0.0;

    // Prepare the last N month buckets (oldest -> newest).
    final buckets = <DateTime, MonthlyBucketBuilder>{};
    for (var i = monthsShown - 1; i >= 0; i--) {
      final m = DateTime(now.year, now.month - i);
      buckets[DateTime(m.year, m.month)] = MonthlyBucketBuilder(m);
    }

    final categoryTotals = <TransactionCategory, double>{};

    for (final t in transactions) {
      final monthKey = DateTime(t.date.year, t.date.month);
      final bucket = buckets[monthKey];
      if (bucket != null) {
        if (t.type == TransactionType.expense) {
          bucket.expense += t.amount;
        } else if (t.type == TransactionType.income) {
          bucket.income += t.amount;
        }
      }

      if (monthKey == currentMonth) {
        if (t.type == TransactionType.expense) {
          monthExpense += t.amount;
          categoryTotals.update(
            t.category,
            (v) => v + t.amount,
            ifAbsent: () => t.amount,
          );
        } else if (t.type == TransactionType.income) {
          monthIncome += t.amount;
        }
      }
    }

    final breakdown = categoryTotals.entries
        .map((e) => CategorySpend(category: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return DashboardSummary(
      totalBalance: totalBalance,
      monthIncome: monthIncome,
      monthExpense: monthExpense,
      monthlyBuckets: buckets.values.map((b) => b.build()).toList(),
      categoryBreakdown: breakdown,
      recent: transactions.take(6).toList(),
    );
  }
}

class MonthlyBucketBuilder {
  final DateTime month;
  double expense = 0;
  double income = 0;

  MonthlyBucketBuilder(this.month);

  MonthlyBucket build() =>
      MonthlyBucket(month: month, expense: expense, income: income);
}
