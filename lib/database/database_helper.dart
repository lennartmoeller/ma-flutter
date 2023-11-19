import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String _dbName = "finance.db";
  static const int _dbVersion = 1;
  static Database? _database;

  static Future<Database> getDatabaseConnector() async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), _dbName);
    //databaseFactory.deleteDatabase(dbPath);
    return openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        await _createTables(db);
      },
      onOpen: (Database db) async {
        if (await _isDatabaseInitialized(db)) {
          await _clearAllTables(db);
        }
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute(
      'CREATE TABLE accounts(id INTEGER PRIMARY KEY, label TEXT NOT NULL, start_balance INTEGER NOT NULL DEFAULT 0, icon TEXT)',
    );
    await db.execute(
      'CREATE TABLE categories(id INTEGER PRIMARY KEY, label TEXT NOT NULL, type INTEGER NOT NULL DEFAULT 2, icon TEXT)',
    );
    await db.execute(
      'CREATE TABLE transactions(id INTEGER PRIMARY KEY, date TEXT NOT NULL, account INTEGER NOT NULL, category INTEGER NOT NULL, description TEXT, amount INTEGER NOT NULL, receipt STRING)',
    );
  }

  static Future<bool> _isDatabaseInitialized(Database db) async {
    try {
      List<Map> tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      return tables.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _clearAllTables(Database db) async {
    List<Map> tables = await db
        .rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");
    for (Map table in tables) {
      await db.delete(table['name'].toString());
    }
  }
}
