import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final AccountRepository _repository;
  StreamSubscription<List<AccountEntity>>? _subscription;

  AccountsCubit(this._repository) : super(const AccountsState());

  void subscribe() {
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (accounts) => emit(AccountsState(
        status: AccountsStatus.ready,
        accounts: accounts,
      )),
    );
  }

  Future<void> save(AccountEntity account) => _repository.add(account);

  Future<void> delete(String id) => _repository.delete(id);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
