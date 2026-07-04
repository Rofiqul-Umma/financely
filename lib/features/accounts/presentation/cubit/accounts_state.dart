part of 'accounts_cubit.dart';

enum AccountsStatus { loading, ready }

class AccountsState extends Equatable {
  final AccountsStatus status;
  final List<AccountEntity> accounts;

  const AccountsState({
    this.status = AccountsStatus.loading,
    this.accounts = const [],
  });

  AccountEntity? byId(String? id) {
    if (id == null) return null;
    for (final a in accounts) {
      if (a.id == id) return a;
    }
    return null;
  }

  @override
  List<Object?> get props => [status, accounts];
}
