import 'dart:async';

import 'package:finances_flutter/utility/database/database_helper.dart';
import 'package:finances_flutter/utility/database/row.dart';
import 'package:finances_flutter/utility/german_date.dart';
import 'package:sqflite/sqflite.dart';

class Transaction extends Row {
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
    required this.description,
    required this.amount,
  });

  static Future<Map<int, Transaction>> getAll() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return {for (var map in maps) map['id'] as int: Transaction.fromJson(map)};
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      date: GermanDate(json['date'] as String),
      account: json['account'] as int,
      category: json['category'] as int,
      description: json['description'] as String,
      amount: json['amount'] as int,
    );
  }

  @override
  Map<String, Object?> toJson() {
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
