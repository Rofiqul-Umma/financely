part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardSummary summary;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.summary = const DashboardSummary.empty(),
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardSummary? summary,
  }) {
    return DashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [status, summary];
}
