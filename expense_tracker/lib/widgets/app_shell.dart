import 'package:flutter/material.dart';

import '../pages/budget_page.dart';
import '../pages/history_page.dart';
import '../pages/settings_page.dart';
import '../pages/stats_page.dart';
import '../services/app_state.dart';
import 'expenses.dart';
import 'new_expense.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _titles = [
    'Flutter Expense Tracker',
    'History',
    'Insights',
    'Budget',
    'Settings',
  ];

  static const _pages = [
    Expenses(),
    HistoryPage(),
    StatsPage(),
    BudgetPage(),
    SettingsPage(),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: appState.addExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          if (_index <= 1)
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Insights'),
          NavigationDestination(icon: Icon(Icons.savings), label: 'Budget'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
