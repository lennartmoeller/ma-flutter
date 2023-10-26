import 'dart:async';

import 'package:finances_flutter/utility/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

abstract class Row {
  String get tableName;

  abstract int id;

  Future<void> insert() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    await db.insert(
      tableName,
      toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update() async {
    final Database db = await DatabaseHelper.getDatabaseConnector();
    await db.update(
      tableName,
      toJson(),
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

  Map<String, Object?> toJson() {
    throw UnimplementedError();
  }
}
