import 'dart:async';

import 'package:finances_flutter/utility/database/database_helper.dart';
import 'package:finances_flutter/utility/database/row.dart';
import 'package:sqflite/sqflite.dart';

class Category extends Row {
  @override
  String get tableName => 'categories';

  @override
  int id;
  String label;
  int type;

  Category({
    required this.id,
    required this.label,
    required this.type,
  });

  static Future<Map<int, Category>> getAll() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return {for (var map in maps) map['id'] as int: Category.fromJson(map)};
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      label: json['label'] as String,
      type: json['type'] as int,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type,
    };
  }
}
