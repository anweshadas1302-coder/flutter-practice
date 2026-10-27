import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum ExpenseCategory { food, travel, leisure, work }

const categoryIcons = {
  ExpenseCategory.food: Icons.restaurant,
  ExpenseCategory.travel: Icons.flight_takeoff,
  ExpenseCategory.leisure: Icons.movie,
  ExpenseCategory.work: Icons.work,
};

class Expense {
  Expense({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  String get formattedDate {
    return formatter.format(date);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      category: ExpenseCategory.values.byName(map['category'] as String),
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses = allExpenses
          .where((expense) => expense.category == category)
          .toList();

  final ExpenseCategory category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
