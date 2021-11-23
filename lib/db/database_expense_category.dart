// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Expense category database

class ExpenseCategoryDb {
  final int? id;
  final String? expenseCategory;

  ExpenseCategoryDb({this.id, this.expenseCategory});

  ExpenseCategoryDb.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        expenseCategory = res['expenseCategory'];

  Map<String, Object?> toMap() {
    return {'id': id, 'expenseCategory': expenseCategory};
  }
}

class DatabaseHandlerExpenseCategory extends GetxController {
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
      join(path, 'expenseCategory.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE expenseCategories(id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' expenseCategory TEXT NOT NULL)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertExpenseCategory(
      List<ExpenseCategoryDb> expenseCategories) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var expenseCategory in expenseCategories) {
      result = await db.insert('expenseCategories', expenseCategory.toMap());
    }
    return result;
  }

  Future<List<ExpenseCategoryDb>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('expenseCategories');
    return queryResult.map((e) => ExpenseCategoryDb.fromMap(e)).toList();
  }

  Future<void> deleteExpenseCategory(int id) async {
    final db = await initializeDB();
    await db.delete(
      'expenseCategories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<dynamic>> listExpenseCategory() async {
    final dbClient = await initializeDB();
    final result = await dbClient
        .rawQuery('SELECT expenseCategory FROM expenseCategories');
    final expenseCate = [];
    for (int x = 0; x < result.length; x++) {
      debugPrint('${result[x].values}');
      expenseCate.add(result[x]
          .values
          .toString()
          .replaceAll(RegExp(r'\p{P}', unicode: true), ''));
    }
    return expenseCate;
  }

  Future<void> deleteDb() async {
    final db = await initializeDB();
    await db.rawQuery('delete from expenseCategories');
  }
}
