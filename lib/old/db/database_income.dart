// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransDb {
  final int? id;
  final String? trans;
  final String? date;
  final String? account;
  final String? category;
  final double? amount;
  final String? note;

  TransDb(
      {this.id,
      this.trans,
      this.date,
      this.account,
      this.category,
      this.amount,
      this.note});

  TransDb.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        trans = res['trans'],
        date = res['date'],
        account = res['account'],
        category = res['category'],
        amount = res['amount'],
        note = res['amount'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'trans': trans,
      'date': date,
      'account': account,
      'category': category,
      'amount': amount,
      'note': note
    };
  }
}

class DatabaseHandler extends GetxController{
  Database? _database;

  Future<Database?> get database async {
    debugPrint('database getter called');

    if (_database != null) {
      return _database;
    }

    _database = await initializeDB();

    return _database;
  }

  Future<Database> initializeDB() async {
    final String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'transaction.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' trans TEXT NOT NULL, date TEXT NOT NULL, account TEXT NOT NULL,'
              ' category TEXT NOT NULL, amount INTEGER NOT NULL, note TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertTrans(List<TransDb> transactions) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var transaction in transactions) {
      result = await db.insert('transactions', transaction.toMap());
    }
    return result;
  }

  Future<List<TransDb>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('transactions');
    return queryResult.map((e) => TransDb.fromMap(e)).toList();
  }

  Future<void> deleteTrans(int id) async {
    final db = await initializeDB();
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
