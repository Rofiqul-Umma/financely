import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/usecases/watch_accounts.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/usecases/transaction_usecases.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/build_dashboard_summary.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final WatchTransactions _watchTransactions;
  final WatchAccounts _watchAccounts;
  final BuildDashboardSummary _buildSummary;

  DashboardBloc({
    required WatchTransactions watchTransactions,
    required WatchAccounts watchAccounts,
    required BuildDashboardSummary buildSummary,
  })  : _watchTransactions = watchTransactions,
        _watchAccounts = watchAccounts,
        _buildSummary = buildSummary,
        super(const DashboardState()) {
    on<DashboardSubscriptionRequested>(_onSubscribe);
  }

  Future<void> _onSubscribe(
    DashboardSubscriptionRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    await emit.forEach<DashboardSummary>(
      _summaryStream(),
      onData: (summary) => state.copyWith(
        status: DashboardStatus.success,
        summary: summary,
      ),
      onError: (_, __) => state.copyWith(status: DashboardStatus.failure),
    );
  }

  /// Combines the transaction and account streams, re-emitting a summary
  /// whenever either changes. Waits for the first value from both so the
  /// total balance reflects opening balances from the start.
  Stream<DashboardSummary> _summaryStream() {
    final controller = StreamController<DashboardSummary>();
    List<TransactionEntity> transactions = const [];
    List<AccountEntity> accounts = const [];
    var hasTransactions = false;
    var hasAccounts = false;

    void emitIfReady() {
      if (hasTransactions && hasAccounts) {
        controller.add(_buildSummary(transactions, accounts));
      }
    }

    final txSub = _watchTransactions().listen(
      (data) {
        transactions = data;
        hasTransactions = true;
        emitIfReady();
      },
      onError: controller.addError,
    );
    final accSub = _watchAccounts().listen(
      (data) {
        accounts = data;
        hasAccounts = true;
        emitIfReady();
      },
      onError: controller.addError,
    );

    controller.onCancel = () async {
      await txSub.cancel();
      await accSub.cancel();
    };

    return controller.stream;
  }
}
