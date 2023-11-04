import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabaseConnector() async {
    return _database ?? await _initDatabase();
  }

  static Future<Database> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "finance.db"),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE accounts(id INTEGER PRIMARY KEY, label TEXT NOT NULL, start_balance INTEGER NOT NULL DEFAULT 0, icon TEXT)',
        );
        await db.execute(
          'CREATE TABLE categories(id INTEGER PRIMARY KEY, label TEXT NOT NULL, type INTEGER NOT NULL DEFAULT 2, icon TEXT)',
        );
        await db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY, date TEXT NOT NULL, account INTEGER NOT NULL, category INTEGER NOT NULL, description TEXT, amount INTEGER NOT NULL)',
        );
      },
      version: 1,
    );
    return _database!;
  }
}
