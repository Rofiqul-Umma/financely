import 'package:equatable/equatable.dart';

import 'transaction_enums.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String title;

  /// Always stored as a positive magnitude; direction comes from [type].
  final double amount;
  final TransactionType type;
  final TransactionCategory category;

  /// User-provided name shown instead of [category]'s label. Set when the user
  /// picks "Other" and types their own category.
  final String? customLabel;
  final PaymentMethod paymentMethod;

  /// Owning account; for transfers this is the source account.
  final String? accountId;

  /// Destination account, set only for transfers.
  final String? toAccountId;
  final DateTime date;
  final String? note;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    this.customLabel,
    required this.paymentMethod,
    this.accountId,
    this.toAccountId,
    required this.date,
    this.note,
  });

  /// Positive for income, negative for expense; transfers are balance-neutral.
  double get signedAmount => switch (type) {
        TransactionType.income => amount,
        TransactionType.expense => -amount,
        TransactionType.transfer => 0,
      };

  /// Label to display for the category — the custom name when present.
  String get categoryLabel {
    final custom = customLabel?.trim();
    return (custom != null && custom.isNotEmpty) ? custom : category.label;
  }

  TransactionEntity copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    TransactionCategory? category,
    String? customLabel,
    PaymentMethod? paymentMethod,
    String? accountId,
    String? toAccountId,
    DateTime? date,
    String? note,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      customLabel: customLabel ?? this.customLabel,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        type,
        category,
        customLabel,
        paymentMethod,
        accountId,
        toAccountId,
        date,
        note,
      ];
}
