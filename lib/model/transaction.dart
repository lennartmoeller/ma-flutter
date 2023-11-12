import 'dart:async';

import 'package:ma_flutter/database/database_helper.dart';
import 'package:ma_flutter/database/database_row.dart';
import 'package:ma_flutter/util/german_date.dart';
import 'package:sqflite/sqflite.dart';

class Transaction extends DatabaseRow {
  @override
  String get tableName => 'transactions';

  @override
  int id;
  GermanDate date;
  int account;
  int category;
  String? description;
  int amount;

  Transaction({
    required this.id,
    required this.date,
    required this.account,
    required this.category,
    this.description,
    required this.amount,
  });

  static Future<Map<int, Transaction>> getAll() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return {for (var map in maps) map['id'] as int: Transaction.fromMap(map)};
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int,
      date: GermanDate(map['date'] as String),
      account: map['account'] as int,
      category: map['category'] as int,
      description: map['description'] as String,
      amount: map['amount'] as int,
    );
  }

  @override
  void updateFromMap(Map<String, dynamic> map) {
    id = map['id'] ?? id;
    date = map['date'] ?? date;
    account = map['account'] ?? account;
    category = map['category'] ?? category;
    description = map.containsKey('description') ? map['description'] : description;
    amount = map['amount'] ?? amount;
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date': date.toString(),
      'account': account,
      'category': category,
      'description': description,
      'amount': amount,
    };
  }
}
