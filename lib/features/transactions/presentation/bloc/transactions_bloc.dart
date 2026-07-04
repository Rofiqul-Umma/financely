import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/transaction_usecases.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final WatchTransactions _watchTransactions;
  final AddTransaction _addTransaction;
  final DeleteTransaction _deleteTransaction;

  StreamSubscription<List<TransactionEntity>>? _subscription;

  TransactionsBloc({
    required WatchTransactions watchTransactions,
    required AddTransaction addTransaction,
    required DeleteTransaction deleteTransaction,
  })  : _watchTransactions = watchTransactions,
        _addTransaction = addTransaction,
        _deleteTransaction = deleteTransaction,
        super(const TransactionsState()) {
    on<TransactionsSubscriptionRequested>(_onSubscribe);
    on<_TransactionsUpdated>(_onUpdated);
    on<TransactionAdded>(_onAdded);
    on<TransactionDeleted>(_onDeleted);
  }

  Future<void> _onSubscribe(
    TransactionsSubscriptionRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    await _subscription?.cancel();
    await emit.forEach<List<TransactionEntity>>(
      _watchTransactions(),
      onData: (transactions) => state.copyWith(
        status: TransactionsStatus.success,
        transactions: transactions,
      ),
      onError: (_, __) =>
          state.copyWith(status: TransactionsStatus.failure, error: 'Load failed'),
    );
  }

  void _onUpdated(
    _TransactionsUpdated event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(
      status: TransactionsStatus.success,
      transactions: event.transactions,
    ));
  }

  Future<void> _onAdded(
    TransactionAdded event,
    Emitter<TransactionsState> emit,
  ) async {
    await _addTransaction(event.transaction);
  }

  Future<void> _onDeleted(
    TransactionDeleted event,
    Emitter<TransactionsState> emit,
  ) async {
    await _deleteTransaction(event.id);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
