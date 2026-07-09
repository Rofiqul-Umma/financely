part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

/// Start listening to the persisted transaction stream.
class TransactionsSubscriptionRequested extends TransactionsEvent {
  const TransactionsSubscriptionRequested();
}

class _TransactionsUpdated extends TransactionsEvent {
  final List<TransactionEntity> transactions;
  const _TransactionsUpdated(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class TransactionAdded extends TransactionsEvent {
  final TransactionEntity transaction;
  const TransactionAdded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeleted extends TransactionsEvent {
  final String id;
  const TransactionDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

/// Sets or clears the date-range filter. A null [start] and [end] clears it.
class TransactionsFilterChanged extends TransactionsEvent {
  final DateTime? start;
  final DateTime? end;
  const TransactionsFilterChanged({this.start, this.end});

  @override
  List<Object?> get props => [start, end];
}
