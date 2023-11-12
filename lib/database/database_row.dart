import 'dart:async';

import 'package:ma_flutter/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseRow {
  String get tableName;

  abstract int id;

  Future<void> insert() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    await db.insert(
      tableName,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    await db.update(
      tableName,
      toMap(),
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void updateFromMap(Map<String, dynamic> map);

  Map<String, Object?> toMap();
}
