import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';
import 'expense_storage.dart';

class AppState extends ChangeNotifier {
  final List<Expense> expenses = [];
  ThemeMode themeMode = ThemeMode.system;
  String currency = '\$';
  double monthlyBudget = 0;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    expenses
      ..clear()
      ..addAll(await ExpenseStorage.load());

    final savedTheme = prefs.getString('themeMode');
    themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == savedTheme,
      orElse: () => ThemeMode.system,
    );
    currency = prefs.getString('currency') ?? '\$';
    monthlyBudget = prefs.getDouble('budget') ?? 0;
    notifyListeners();
  }

  double get totalSpent {
    double sum = 0;
    for (final e in expenses) {
      sum += e.amount;
    }
    return sum;
  }

  double get thisMonthSpent {
    final now = DateTime.now();
    double sum = 0;
    for (final e in expenses) {
      if (e.date.year == now.year && e.date.month == now.month) {
        sum += e.amount;
      }
    }
    return sum;
  }

  void addExpense(Expense expense) {
    expenses.add(expense);
    ExpenseStorage.save(expenses);
    notifyListeners();
  }

  /// Removes the expense and returns its old index (used for Undo).
  int removeExpense(Expense expense) {
    final index = expenses.indexOf(expense);
    expenses.remove(expense);
    ExpenseStorage.save(expenses);
    notifyListeners();
    return index;
  }

  void insertExpense(int index, Expense expense) {
    final safeIndex = index.clamp(0, expenses.length);
    expenses.insert(safeIndex, expense);
    ExpenseStorage.save(expenses);
    notifyListeners();
  }

  Future<void> clearAll() async {
    expenses.clear();
    await ExpenseStorage.save(expenses);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
  }

  Future<void> setCurrency(String symbol) async {
    currency = symbol;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', symbol);
  }

  Future<void> setBudget(double amount) async {
    monthlyBudget = amount;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('budget', amount);
  }
}

final appState = AppState();
