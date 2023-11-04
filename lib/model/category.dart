import 'dart:async';

import 'package:ma_flutter/database/database_helper.dart';
import 'package:ma_flutter/database/row.dart';
import 'package:sqflite/sqflite.dart';

class Category extends Row {
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
    required this.icon,
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
      icon: json['icon'] as String?,
    );
  }

  @override
  Map<String, Object?> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type,
      'icon': icon,
    };
  }
}
