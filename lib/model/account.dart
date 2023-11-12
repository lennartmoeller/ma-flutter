import 'dart:async';

import 'package:ma_flutter/database/database_helper.dart';
import 'package:ma_flutter/database/database_row.dart';
import 'package:sqflite/sqflite.dart';

class Account extends DatabaseRow {
  @override
  String get tableName => 'accounts';

  @override
  int id;
  String label;
  int startBalance;
  String? icon;

  Account({
    required this.id,
    required this.label,
    required this.startBalance,
    this.icon,
  });

  static Future<Map<int, Account>> getAll() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    final List<Map<String, dynamic>> maps = await db.query('accounts');
    return {for (var map in maps) map['id'] as int: Account.fromMap(map)};
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as int,
      label: map['label'] as String,
      startBalance: map['start_balance'] as int,
      icon: map['icon'] as String?,
    );
  }

  @override
  void updateFromMap(Map<String, dynamic> map) {
    id = map['id'] ?? id;
    label = map['label'] ?? label;
    startBalance = map['start_balance'] ?? startBalance;
    icon = map.containsKey('icon') ? map['icon'] : icon;
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'label': label,
      'start_balance': startBalance,
      'icon': icon,
    };
  }
}
