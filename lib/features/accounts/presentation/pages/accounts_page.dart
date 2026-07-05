import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../transactions/presentation/bloc/transactions_bloc.dart';
import '../../domain/entities/account.dart';
import '../../domain/usecases/account_balance.dart';
import '../cubit/accounts_cubit.dart';
import '../utils/account_visuals.dart';
import 'add_account_page.dart';

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AccountsCubit>().state.accounts;
    final transactions =
        context.watch<TransactionsBloc>().state.transactions;
    final currencyCode =
        context.select((SettingsCubit c) => c.state.currencyCode);

    final total = accounts.fold<double>(
      0,
      (sum, a) => sum + accountBalance(a, transactions),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _NetWorthCard(total: total, currencyCode: currencyCode),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    onPressed: () => AddAccountPage.show(context),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(AppLocalizations.of(context).newAccount),
                  ),
                ),
                const SizedBox(height: 4),
                if (accounts.isEmpty)
                  const _EmptyAccounts()
                else
                  for (final account in accounts)
                    _AccountCard(
                      account: account,
                      balance: accountBalance(account, transactions),
                      currencyCode: currencyCode,
                      onTap: () =>
                          AddAccountPage.show(context, initial: account),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NetWorthCard extends StatelessWidget {
  final double total;
  final String currencyCode;

  const _NetWorthCard({required this.total, required this.currencyCode});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).totalAcrossAccounts,
              style: TextStyle(color: scheme.onPrimaryContainer),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                Formatters.currency(total, code: currencyCode),
                maxLines: 1,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final AccountEntity account;
  final double balance;
  final String currencyCode;
  final VoidCallback onTap;

  const _AccountCard({
    required this.account,
    required this.balance,
    required this.currencyCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final negative = balance < 0;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: account.color.withValues(alpha: 0.15),
          child: Icon(account.icon, color: account.color),
        ),
        title: Text(
          account.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          AppLocalizations.of(context).opening(
            Formatters.currency(account.openingBalance, code: currencyCode),
          ),
        ),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 130),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              Formatters.currency(balance, code: currencyCode),
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: negative ? scheme.error : scheme.onSurface,
              ),
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _EmptyAccounts extends StatelessWidget {
  const _EmptyAccounts();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 64, color: scheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context).noAccountsYet,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context).addOneToStart,
              style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
