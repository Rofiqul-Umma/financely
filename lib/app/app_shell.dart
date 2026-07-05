import 'package:flutter/material.dart';

import '../core/responsive/responsive.dart';
import '../features/accounts/presentation/pages/accounts_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/transactions/presentation/pages/add_transaction_page.dart';
import '../features/transactions/presentation/pages/transactions_page.dart';
import '../l10n/app_localizations.dart';

class _Destination {
  final IconData icon;
  final IconData selectedIcon;
  const _Destination(this.icon, this.selectedIcon);
}

const _destinations = <_Destination>[
  _Destination(Icons.dashboard_outlined, Icons.dashboard_rounded),
  _Destination(Icons.receipt_long_outlined, Icons.receipt_long_rounded),
  _Destination(
    Icons.account_balance_wallet_outlined,
    Icons.account_balance_wallet_rounded,
  ),
  _Destination(Icons.settings_outlined, Icons.settings_rounded),
];

String _navLabel(AppLocalizations l, int index) => switch (index) {
      0 => l.navDashboard,
      1 => l.navTransactions,
      2 => l.navAccounts,
      _ => l.navSettings,
    };

/// Hosts the three primary destinations with an adaptive navigation surface:
/// a bottom bar on phones, a navigation rail on tablets and larger.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _select(int value) => setState(() => _index = value);

  bool get _showFab => _index != 3; // hide on Settings

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(onSeeAllTransactions: () => _select(1)),
      const TransactionsPage(),
      const AccountsPage(),
      const SettingsPage(),
    ];
    final body = IndexedStack(index: _index, children: pages);

    return context.isCompact
        ? _buildCompact(context, body)
        : _buildExpanded(context, body);
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(_navLabel(AppLocalizations.of(context), _index)),
      titleTextStyle: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      toolbarHeight: 72,
    );
  }

  Widget _buildCompact(BuildContext context, Widget body) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(child: body),
      floatingActionButton: _showFab
          ? FloatingActionButton.extended(
              onPressed: () => AddTransactionPage.show(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(l.addExpense),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _select,
        destinations: [
          for (var i = 0; i < _destinations.length; i++)
            NavigationDestination(
              icon: Icon(_destinations[i].icon),
              selectedIcon: Icon(_destinations[i].selectedIcon),
              label: _navLabel(l, i),
            ),
        ],
      ),
    );
  }

  Widget _buildExpanded(BuildContext context, Widget body) {
    final extended = context.isExpandedOrLarger;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            _NavRail(
              index: _index,
              extended: extended,
              onSelected: _select,
              onAdd: () => AddTransactionPage.show(context),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Scaffold(
                backgroundColor: scheme.surface,
                appBar: _appBar(context),
                body: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavRail extends StatelessWidget {
  final int index;
  final bool extended;
  final ValueChanged<int> onSelected;
  final VoidCallback onAdd;

  const _NavRail({
    required this.index,
    required this.extended,
    required this.onSelected,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.sizeOf(context).height -
              MediaQuery.paddingOf(context).vertical,
        ),
        child: IntrinsicHeight(
          child: NavigationRail(
            extended: extended,
            selectedIndex: index,
            onDestinationSelected: onSelected,
            groupAlignment: -0.9,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: extended
                  ? FloatingActionButton.extended(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l.addExpense),
                    )
                  : FloatingActionButton(
                      onPressed: onAdd,
                      child: const Icon(Icons.add_rounded),
                    ),
            ),
            destinations: [
              for (var i = 0; i < _destinations.length; i++)
                NavigationRailDestination(
                  icon: Icon(_destinations[i].icon),
                  selectedIcon: Icon(_destinations[i].selectedIcon),
                  label: Text(_navLabel(l, i)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
