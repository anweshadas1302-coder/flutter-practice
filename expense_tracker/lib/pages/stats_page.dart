import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';
import '../services/app_state.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  Widget _section(BuildContext context, String title, Widget child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _barRow(String label, String value, double fraction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label), Text(value)],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: fraction.clamp(0.0, 1.0),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final expenses = appState.expenses;
        if (expenses.isEmpty) {
          return const Center(
            child: Text('Add some expenses to see insights.'),
          );
        }

        final c = appState.currency;
        final total = appState.totalSpent;
        final average = total / expenses.length;
        final highest = expenses.reduce((a, b) => a.amount >= b.amount ? a : b);

        final byCategory = {
          for (final cat in ExpenseCategory.values)
            cat: expenses
                .where((e) => e.category == cat)
                .fold<double>(0, (sum, e) => sum + e.amount),
        };

        final now = DateTime.now();
        final months = [
          for (var i = 5; i >= 0; i--) DateTime(now.year, now.month - i),
        ];
        final monthTotals = [
          for (final m in months)
            expenses
                .where((e) => e.date.year == m.year && e.date.month == m.month)
                .fold<double>(0, (sum, e) => sum + e.amount),
        ];
        double maxMonth = 0;
        for (final t in monthTotals) {
          if (t > maxMonth) maxMonth = t;
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _section(
              context,
              'Overview',
              Column(
                children: [
                  _statRow('Total spent', '$c${total.toStringAsFixed(2)}'),
                  _statRow('Number of expenses', '${expenses.length}'),
                  _statRow(
                    'Average expense',
                    '$c${average.toStringAsFixed(2)}',
                  ),
                  _statRow(
                    'Highest expense',
                    '${highest.title} ($c${highest.amount.toStringAsFixed(2)})',
                  ),
                ],
              ),
            ),
            _section(
              context,
              'By category',
              Column(
                children: [
                  for (final cat in ExpenseCategory.values)
                    _barRow(
                      cat.name[0].toUpperCase() + cat.name.substring(1),
                      '$c${byCategory[cat]!.toStringAsFixed(2)}'
                      '  (${total == 0 ? 0 : (byCategory[cat]! / total * 100).round()}%)',
                      total == 0 ? 0 : byCategory[cat]! / total,
                    ),
                ],
              ),
            ),
            _section(
              context,
              'Last 6 months',
              Column(
                children: [
                  for (var i = 0; i < months.length; i++)
                    _barRow(
                      DateFormat.yMMM().format(months[i]),
                      '$c${monthTotals[i].toStringAsFixed(2)}',
                      maxMonth == 0 ? 0 : monthTotals[i] / maxMonth,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
