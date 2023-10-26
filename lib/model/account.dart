import 'dart:async';

import 'package:finances_flutter/utility/database/database_helper.dart';
import 'package:finances_flutter/utility/database/row.dart';
import 'package:sqflite/sqflite.dart';

class Account extends Row {
  @override
  String get tableName => 'accounts';

  @override
  int id;
  String label;
  int startBalance;

  Account({
    required this.id,
    required this.label,
    required this.startBalance,
  });

  static Future<Map<int, Account>> getAll() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    final List<Map<String, dynamic>> maps = await db.query('accounts');
    return {for (var map in maps) map['id'] as int: Account.fromJson(map)};
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int,
      label: json['label'] as String,
      startBalance: json['start_balance'] as int,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'label': label,
      'start_balance': startBalance,
    };
  }
}
