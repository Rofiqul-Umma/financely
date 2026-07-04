import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_enums.dart';
import '../entities/account.dart';

/// Pure computation of an account's current balance from its opening balance
/// plus every transaction that moves money in or out of it.
double accountBalance(
  AccountEntity account,
  List<TransactionEntity> transactions,
) {
  var balance = account.openingBalance;
  for (final t in transactions) {
    switch (t.type) {
      case TransactionType.income:
        if (t.accountId == account.id) balance += t.amount;
      case TransactionType.expense:
        if (t.accountId == account.id) balance -= t.amount;
      case TransactionType.transfer:
        if (t.accountId == account.id) balance -= t.amount;
        if (t.toAccountId == account.id) balance += t.amount;
    }
  }
  return balance;
}
