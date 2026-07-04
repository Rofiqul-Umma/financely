import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/usecases/transaction_usecases.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/build_dashboard_summary.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final WatchTransactions _watchTransactions;
  final BuildDashboardSummary _buildSummary;

  DashboardBloc({
    required WatchTransactions watchTransactions,
    required BuildDashboardSummary buildSummary,
  })  : _watchTransactions = watchTransactions,
        _buildSummary = buildSummary,
        super(const DashboardState()) {
    on<DashboardSubscriptionRequested>(_onSubscribe);
  }

  Future<void> _onSubscribe(
    DashboardSubscriptionRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    await emit.forEach<List<TransactionEntity>>(
      _watchTransactions(),
      onData: (transactions) => state.copyWith(
        status: DashboardStatus.success,
        summary: _buildSummary(transactions),
      ),
      onError: (_, __) => state.copyWith(status: DashboardStatus.failure),
    );
  }
}
