import 'package:flutter/material.dart';

import '../services/app_state.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  Future<void> _editBudget(BuildContext context) async {
    final controller = TextEditingController(
      text: appState.monthlyBudget > 0
          ? appState.monthlyBudget.toStringAsFixed(0)
          : '',
    );

    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Monthly budget'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            prefixText: '${appState.currency} ',
            labelText: 'Amount',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(ctx, double.tryParse(controller.text.trim())),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result >= 0) {
      appState.setBudget(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final c = appState.currency;
        final budget = appState.monthlyBudget;
        final spent = appState.thisMonthSpent;
        final scheme = Theme.of(context).colorScheme;

        if (budget <= 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.savings, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'You have not set a monthly budget yet.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => _editBudget(context),
                    child: const Text('Set budget'),
                  ),
                ],
              ),
            ),
          );
        }

        final ratio = spent / budget;
        final remaining = budget - spent;
        final now = DateTime.now();
        final daysLeft = DateTime(now.year, now.month + 1, 0).day - now.day + 1;

        Color barColor = scheme.primary;
        String status = 'You are on track.';
        if (ratio >= 1) {
          barColor = scheme.error;
          status = 'You have exceeded your budget!';
        } else if (ratio >= 0.8) {
          barColor = Colors.orange;
          status = 'Careful, you have used over 80% of your budget.';
        }

        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This month',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$c${spent.toStringAsFixed(2)} of $c${budget.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: ratio.clamp(0.0, 1.0),
                      minHeight: 14,
                      color: barColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      status,
                      style: TextStyle(
                        color: barColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      remaining >= 0
                          ? 'Remaining: $c${remaining.toStringAsFixed(2)}'
                          : 'Over budget by: $c${(-remaining).toStringAsFixed(2)}',
                    ),
                    if (remaining > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'You can spend about $c${(remaining / daysLeft).toStringAsFixed(2)} per day '
                        'for the remaining $daysLeft days.',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () => _editBudget(context),
                icon: const Icon(Icons.edit),
                label: const Text('Change budget'),
              ),
            ),
          ],
        );
      },
    );
  }
}
