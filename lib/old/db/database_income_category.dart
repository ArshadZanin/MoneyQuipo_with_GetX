// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///income category database

class IncomeCategoryDb {
  final int? id;
  final String? incomeCategory;

  IncomeCategoryDb({this.id, this.incomeCategory});

  IncomeCategoryDb.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        incomeCategory = res['incomeCategory'];

  Map<String, Object?> toMap() {
    return {'id': id, 'incomeCategory': incomeCategory};
  }
}


///database handler of income category with getX controller
class DatabaseHandlerIncomeCategory extends GetxController{
  Database? _database;

  Future<Database?> get database async {
    debugPrint('database getter called');

    if (_database != null) {
      return _database;
    }

    _database = await initializeDB();

    return _database;
  }

  ///this function is use to initialize the database
  Future<Database> initializeDB() async {
    final String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'incomeCategory.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE incomeCategories(id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' incomeCategory TEXT NOT NULL)',
        );
      },
      version: 1,
    );
  }


  ///this function is used to insert the income category into database
  Future<int> insertIncomeCategory(
      List<IncomeCategoryDb> incomeCategories) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var incomeCategory in incomeCategories) {
      result = await db.insert('incomeCategories', incomeCategory.toMap());
    }
    return result;
  }

  ///this function is used to update income category into database
  Future<int> updateIncomeCategory(
      int id, String category) async {
    final db = await database;
    final data = {
      'incomeCategory': category
    };
    final result = await db!.update(
        'incomeCategories', data, where: 'id = ?', whereArgs: [id]
    );
    return result;
  }

  ///this function is used to fetch data from database
  Future<List<IncomeCategoryDb>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('incomeCategories');
    return queryResult.map((e) => IncomeCategoryDb.fromMap(e)).toList();
  }

  ///this function is used to delete data from database with the id of the row
  Future<void> deleteIncomeCategory(int id) async {
    final db = await initializeDB();
    await db.delete(
      'incomeCategories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///this function is used to fetch the category without duplication
  Future<List<dynamic>> listIncomeCategory() async {
    final dbClient = await initializeDB();
    final result =
        await dbClient.rawQuery('SELECT incomeCategory FROM incomeCategories');
    final incomeCate = [];
    for (int x = 0; x < result.length; x++) {
      debugPrint('${result[x].values}');
      incomeCate.add(result[x]
          .values
          .toString()
          .replaceAll(RegExp(r'\p{P}', unicode: true), ''));
    }
    return incomeCate;
  }

  ///this function is used to delete database
  Future<void> deleteDb() async {
    final db = await initializeDB();
    await db.rawQuery('delete from incomeCategories');
  }
}
