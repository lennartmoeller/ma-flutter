import 'dart:async';

import 'package:ma_flutter/database/database_helper.dart';
import 'package:ma_flutter/database/database_row.dart';
import 'package:sqflite/sqflite.dart';

class Category extends DatabaseRow {
  @override
  String get tableName => 'categories';

  @override
  int id;
  String label;
  int type;
  String? icon;

  Category({
    required this.id,
    required this.label,
    required this.type,
    this.icon,
  });

  static Future<Map<int, Category>> getAll() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return {for (var map in maps) map['id'] as int: Category.fromMap(map)};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      label: map['label'] as String,
      type: map['type'] as int,
      icon: map['icon'] as String?,
    );
  }

  @override
  void updateFromMap(Map<String, dynamic> map) {
    id = map['id'] ?? id;
    label = map['label'] ?? label;
    type = map['start_balance'] ?? type;
    icon = map.containsKey('icon') ? map['icon'] : icon;
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'label': label,
      'type': type,
      'icon': icon,
    };
  }
}
