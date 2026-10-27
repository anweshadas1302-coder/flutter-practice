import 'package:flutter/material.dart';

import '../services/app_state.dart';
import 'chart/chart.dart';
import 'delete_helper.dart';
import 'expenses_list/expenses_list.dart';

class Expenses extends StatelessWidget {
  const Expenses({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final c = appState.currency;

        Widget mainContent = const Center(
          child: Text('No expenses found. Start adding some!'),
        );

        if (appState.expenses.isNotEmpty) {
          mainContent = ExpensesList(
            expenses: appState.expenses,
            onRemoveExpense: (expense) => deleteWithUndo(context, expense),
          );
        }

        return Column(
          children: [
            Chart(expenses: appState.expenses),
            Text(
              'This month: $c${appState.thisMonthSpent.toStringAsFixed(2)}   •   '
              'Total: $c${appState.totalSpent.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(child: mainContent),
          ],
        );
      },
    );
  }
}
