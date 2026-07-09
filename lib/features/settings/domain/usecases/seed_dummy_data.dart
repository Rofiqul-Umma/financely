import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_enums.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';

/// Populates the app with roughly six months of demo accounts and
/// transactions. Debug/testing only — surfaced behind `kDebugMode`.
class SeedDummyData {
  final AccountRepository _accounts;
  final TransactionRepository _transactions;
  const SeedDummyData(this._accounts, this._transactions);

  /// Returns the number of transactions inserted.
  Future<int> call() async {
    const uuid = Uuid();
    final rng = Random(42); // Fixed seed for reproducible datasets.

    // Reuse existing accounts if present, otherwise create a small set.
    final existing = await _accounts.getAll();
    final List<AccountEntity> accounts;
    if (existing.isEmpty) {
      accounts = [
        AccountEntity(
            id: uuid.v4(),
            name: 'Cash Wallet',
            colorValue: 0xFF2E7D32,
            iconId: 0,
            openingBalance: 500),
        AccountEntity(
            id: uuid.v4(),
            name: 'Bank Account',
            colorValue: 0xFF1565C0,
            iconId: 1,
            openingBalance: 8000),
        AccountEntity(
            id: uuid.v4(),
            name: 'Credit Card',
            colorValue: 0xFFC62828,
            iconId: 2,
            openingBalance: 0),
      ];
      for (final a in accounts) {
        await _accounts.add(a);
      }
    } else {
      accounts = existing;
    }
    final accountIds = accounts.map((a) => a.id).toList();

    // category -> (sample titles, minAmount, maxAmount)
    final expenseCatalog =
        <TransactionCategory, (List<String>, double, double)>{
      TransactionCategory.food: (
        ['Coffee', 'Lunch', 'Dinner out', 'Bubble tea'],
        4,
        35
      ),
      TransactionCategory.groceries: (
        ['Supermarket', 'Weekly groceries', 'Fruit & veg'],
        15,
        90
      ),
      TransactionCategory.transport: (
        ['Fuel', 'Taxi', 'Bus pass', 'Parking'],
        2,
        60
      ),
      TransactionCategory.shopping: (
        ['Clothes', 'Electronics', 'Home goods'],
        20,
        250
      ),
      TransactionCategory.bills: (
        ['Electricity', 'Water', 'Internet', 'Phone'],
        25,
        150
      ),
      TransactionCategory.entertainment: (
        ['Cinema', 'Streaming', 'Concert', 'Games'],
        8,
        80
      ),
      TransactionCategory.health: (
        ['Pharmacy', 'Doctor visit', 'Gym'],
        10,
        120
      ),
      TransactionCategory.housing: (['Rent', 'Maintenance'], 300, 1200),
      TransactionCategory.travel: (
        ['Flight', 'Hotel', 'Train ticket'],
        40,
        500
      ),
      TransactionCategory.education: (['Course', 'Books'], 15, 200),
    };
    final expenseCats = expenseCatalog.keys.toList();
    final methods = PaymentMethod.values;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(const Duration(days: 182));
    var count = 0;

    for (var day = start;
        !day.isAfter(today);
        day = day.add(const Duration(days: 1))) {
      // Monthly salary on the 1st.
      if (day.day == 1) {
        await _transactions.add(TransactionEntity(
          id: uuid.v4(),
          title: 'Monthly salary',
          amount: 3200 + rng.nextInt(400).toDouble(),
          type: TransactionType.income,
          category: TransactionCategory.salary,
          paymentMethod: PaymentMethod.bank,
          accountId: accountIds[accountIds.length > 1 ? 1 : 0],
          date: DateTime(day.year, day.month, day.day, 9),
          note: 'Payroll',
        ));
        count++;
      }

      // 0-3 expenses per day.
      final n = rng.nextInt(4);
      for (var i = 0; i < n; i++) {
        final cat = expenseCats[rng.nextInt(expenseCats.length)];
        // Keep rent/housing near the start of the month only.
        if (cat == TransactionCategory.housing && day.day > 5) continue;
        final (titles, minA, maxA) = expenseCatalog[cat]!;
        final amount = minA + rng.nextDouble() * (maxA - minA);
        await _transactions.add(TransactionEntity(
          id: uuid.v4(),
          title: titles[rng.nextInt(titles.length)],
          amount: double.parse(amount.toStringAsFixed(2)),
          type: TransactionType.expense,
          category: cat,
          paymentMethod: methods[rng.nextInt(methods.length)],
          accountId: accountIds[rng.nextInt(accountIds.length)],
          date: DateTime(
              day.year, day.month, day.day, 8 + rng.nextInt(12), rng.nextInt(60)),
        ));
        count++;
      }

      // Occasional transfer between accounts (~1 in 10 days).
      if (accountIds.length >= 2 && rng.nextInt(10) == 0) {
        final from = rng.nextInt(accountIds.length);
        final to = (from + 1 + rng.nextInt(accountIds.length - 1)) %
            accountIds.length;
        await _transactions.add(TransactionEntity(
          id: uuid.v4(),
          title: 'Transfer',
          amount: (50 + rng.nextInt(450)).toDouble(),
          type: TransactionType.transfer,
          category: TransactionCategory.transfer,
          paymentMethod: PaymentMethod.bank,
          accountId: accountIds[from],
          toAccountId: accountIds[to],
          date: DateTime(day.year, day.month, day.day, 12),
        ));
        count++;
      }

      // Occasional extra income (~1 in 25 days).
      if (rng.nextInt(25) == 0) {
        final incomeCat = rng.nextBool()
            ? TransactionCategory.gift
            : TransactionCategory.investment;
        await _transactions.add(TransactionEntity(
          id: uuid.v4(),
          title: incomeCat == TransactionCategory.gift
              ? 'Gift received'
              : 'Dividend',
          amount: (30 + rng.nextInt(300)).toDouble(),
          type: TransactionType.income,
          category: incomeCat,
          paymentMethod: PaymentMethod.bank,
          accountId: accountIds[rng.nextInt(accountIds.length)],
          date: DateTime(day.year, day.month, day.day, 15),
        ));
        count++;
      }
    }

    return count;
  }
}
