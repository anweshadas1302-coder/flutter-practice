import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/app_state.dart';

void deleteWithUndo(BuildContext context, Expense expense) {
  final index = appState.removeExpense(expense);
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => appState.insertExpense(index, expense),
      ),
    ),
  );
}
