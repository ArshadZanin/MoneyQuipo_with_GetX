// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//expense database

class ExpenseDb {
  final int? id;
  final String? date;
  final String? account;
  final String? expenseCategory;
  final double? amount;
  final String? note;

  ExpenseDb(
      {this.id,
      this.date,
      this.account,
      this.expenseCategory,
      this.amount,
      this.note});

  ExpenseDb.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        date = res['date'],
        account = res['account'],
        expenseCategory = res['expenseCategory'],
        amount = res['amount'],
        note = res['amount'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'date': date,
      'account': account,
      'expenseCategory': expenseCategory,
      'amount': amount,
      'note': note
    };
  }
}

class DatabaseHandlerExpense extends GetxController {
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
      join(path, 'expenses.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE expense(id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' date TEXT NOT NULL, account TEXT NOT NULL,'
              ' expenseCategory TEXT NOT NULL, amount INTEGER NOT NULL,'
              ' note TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertExpense(List<ExpenseDb> expenses) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var expense in expenses) {
      result = await db.insert('expenses', expense.toMap());
    }
    return result;
  }

  Future<List<ExpenseDb>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('expenses');
    return queryResult.map((e) => ExpenseDb.fromMap(e)).toList();
  }

  Future<void> deleteExpense(int id) async {
    final db = await initializeDB();
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
