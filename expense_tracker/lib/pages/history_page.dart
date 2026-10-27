import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/app_state.dart';
import '../widgets/delete_helper.dart';
import '../widgets/expenses_list/expenses_list.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _query = '';
  ExpenseCategory? _category;

  String _label(ExpenseCategory c) =>
      c.name[0].toUpperCase() + c.name.substring(1);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final filtered =
            appState.expenses
                .where(
                  (e) =>
                      (_category == null || e.category == _category) &&
                      e.title.toLowerCase().contains(_query.toLowerCase()),
                )
                .toList()
              ..sort((a, b) => b.date.compareTo(a.date));

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search expenses',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: _category == null,
                      onSelected: (_) => setState(() => _category = null),
                    ),
                  ),
                  for (final c in ExpenseCategory.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        avatar: Icon(categoryIcons[c], size: 18),
                        label: Text(_label(c)),
                        selected: _category == c,
                        onSelected: (_) => setState(() => _category = c),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('No matching expenses.'))
                  : ExpensesList(
                      expenses: filtered,
                      onRemoveExpense: (e) => deleteWithUndo(context, e),
                    ),
            ),
          ],
        );
      },
    );
  }
}
