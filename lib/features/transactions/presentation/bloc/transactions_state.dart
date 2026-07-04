part of 'transactions_bloc.dart';

enum TransactionsStatus { initial, loading, success, failure }

class TransactionsState extends Equatable {
  final TransactionsStatus status;
  final List<TransactionEntity> transactions;
  final String? error;

  const TransactionsState({
    this.status = TransactionsStatus.initial,
    this.transactions = const [],
    this.error,
  });

  TransactionsState copyWith({
    TransactionsStatus? status,
    List<TransactionEntity>? transactions,
    String? error,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, transactions, error];
}
