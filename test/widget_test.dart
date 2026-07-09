import 'package:financely/features/accounts/domain/entities/account.dart';
import 'package:financely/features/dashboard/domain/usecases/build_dashboard_summary.dart';
import 'package:financely/features/transactions/domain/entities/transaction.dart';
import 'package:financely/features/transactions/domain/entities/transaction_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BuildDashboardSummary', () {
    const build = BuildDashboardSummary();
    const accountId = 'acc-1';

    AccountEntity account({double openingBalance = 0}) {
      return AccountEntity(
        id: accountId,
        name: 'test',
        colorValue: 0,
        iconId: 0,
        openingBalance: openingBalance,
      );
    }

    TransactionEntity tx({
      required double amount,
      required TransactionType type,
      TransactionCategory category = TransactionCategory.food,
      DateTime? date,
    }) {
      return TransactionEntity(
        id: '${amount}_${type.name}_${date?.millisecondsSinceEpoch}',
        title: 'test',
        amount: amount,
        type: type,
        category: category,
        paymentMethod: PaymentMethod.card,
        accountId: accountId,
        date: date ?? DateTime.now(),
      );
    }

    test('returns empty summary for no accounts or transactions', () {
      final summary = build([], []);
      expect(summary.totalBalance, 0);
      expect(summary.monthlyBuckets, isEmpty);
    });

    test('includes account opening balance in total', () {
      final summary = build([], [account(openingBalance: 500)]);
      expect(summary.totalBalance, 500);
    });

    test('total balance is opening balance plus signed transactions', () {
      final summary = build(
        [
          tx(amount: 100, type: TransactionType.income),
          tx(amount: 30, type: TransactionType.expense),
        ],
        [account(openingBalance: 500)],
      );
      expect(summary.totalBalance, 570);
    });

    test('aggregates current-month income and expense', () {
      final now = DateTime.now();
      final summary = build(
        [
          tx(amount: 200, type: TransactionType.income, date: now),
          tx(amount: 50, type: TransactionType.expense, date: now),
          tx(amount: 25, type: TransactionType.expense, date: now),
        ],
        [account()],
      );
      expect(summary.monthIncome, 200);
      expect(summary.monthExpense, 75);
    });

    test('exposes the configured number of month buckets', () {
      final summary = build(
        [tx(amount: 10, type: TransactionType.expense)],
        [account()],
      );
      expect(summary.monthlyBuckets.length, BuildDashboardSummary.monthsShown);
    });
  });
}
