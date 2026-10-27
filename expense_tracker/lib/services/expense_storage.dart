import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';

class ExpenseStorage {
  static const _key = 'expenses';

  static Future<List<Expense>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => Expense.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(expenses.map((e) => e.toMap()).toList());
    await prefs.setString(_key, encoded);
  }
}
