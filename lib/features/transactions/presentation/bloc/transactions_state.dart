part of 'transactions_bloc.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionEntity> transactions;
  final String? error;

  /// Inclusive start of the active date filter (normalized to day start).
  final DateTime? filterStart;

  /// Inclusive end of the active date filter (normalized to day start).
  final DateTime? filterEnd;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.error,
    this.filterStart,
    this.filterEnd,
  });

  bool get isFiltered => filterStart != null || filterEnd != null;

  /// [transactions] narrowed to the active date filter. Comparison is by
  /// calendar day, inclusive of both bounds; either bound may be absent.
  List<TransactionEntity> get filteredTransactions {
    if (!isFiltered) return transactions;
    final start = filterStart;
    final end = filterEnd;
    return transactions.where((t) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      if (start != null && day.isBefore(start)) return false;
      if (end != null && day.isAfter(end)) return false;
      return true;
    }).toList();
  }

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionEntity>? transactions,
    String? error,
    DateTime? filterStart,
    DateTime? filterEnd,
    bool clearFilter = false,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      error: error,
      filterStart: clearFilter ? null : (filterStart ?? this.filterStart),
      filterEnd: clearFilter ? null : (filterEnd ?? this.filterEnd),
    );
  }

  @override
  List<Object?> get props =>
      [status, transactions, error, filterStart, filterEnd];
}
