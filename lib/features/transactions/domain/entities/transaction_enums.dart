enum TransactionType { expense, income, transfer }

extension TransactionTypeX on TransactionType {
  String get label => switch (this) {
        TransactionType.expense => 'Expense',
        TransactionType.income => 'Income',
        TransactionType.transfer => 'Transfer',
      };

  bool get isIncome => this == TransactionType.income;
  bool get isTransfer => this == TransactionType.transfer;

  /// Categories offered for this transaction direction.
  List<TransactionCategory> get categories => switch (this) {
        TransactionType.income => const [
            TransactionCategory.salary,
            TransactionCategory.investment,
            TransactionCategory.gift,
            TransactionCategory.other,
          ],
        TransactionType.expense => const [
            TransactionCategory.food,
            TransactionCategory.groceries,
            TransactionCategory.transport,
            TransactionCategory.shopping,
            TransactionCategory.bills,
            TransactionCategory.entertainment,
            TransactionCategory.health,
            TransactionCategory.housing,
            TransactionCategory.travel,
            TransactionCategory.education,
            TransactionCategory.other,
          ],
        TransactionType.transfer => const [
            TransactionCategory.transfer,
            TransactionCategory.other,
          ],
      };
}

enum PaymentMethod { cash, card, bank }

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.cash => 'Cash',
        PaymentMethod.card => 'Card',
        PaymentMethod.bank => 'Bank',
      };
}

enum TransactionCategory {
  food,
  groceries,
  transport,
  shopping,
  bills,
  entertainment,
  health,
  housing,
  travel,
  education,
  salary,
  investment,
  gift,
  other,
  transfer,
}

extension TransactionCategoryX on TransactionCategory {
  String get label => switch (this) {
        TransactionCategory.food => 'Food & Drink',
        TransactionCategory.groceries => 'Groceries',
        TransactionCategory.transport => 'Transport',
        TransactionCategory.shopping => 'Shopping',
        TransactionCategory.bills => 'Bills',
        TransactionCategory.entertainment => 'Entertainment',
        TransactionCategory.health => 'Health',
        TransactionCategory.housing => 'Housing',
        TransactionCategory.travel => 'Travel',
        TransactionCategory.education => 'Education',
        TransactionCategory.salary => 'Salary',
        TransactionCategory.investment => 'Investment',
        TransactionCategory.gift => 'Gift',
        TransactionCategory.other => 'Other',
        TransactionCategory.transfer => 'Transfer',
      };

  bool get isTypicallyIncome =>
      this == TransactionCategory.salary ||
      this == TransactionCategory.investment ||
      this == TransactionCategory.gift;
}
