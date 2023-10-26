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
          'CREATE TABLE accounts(id INTEGER PRIMARY KEY, label TEXT, start_balance INTEGER)',
        );
        await db.execute(
          'CREATE TABLE categories(id INTEGER PRIMARY KEY, label TEXT, type INTEGER)',
        );
        await db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY, date TEXT, account INTEGER, category INTEGER, description TEXT, amount INTEGER)',
        );
      },
      version: 1,
    );
    return _database!;
  }
}
