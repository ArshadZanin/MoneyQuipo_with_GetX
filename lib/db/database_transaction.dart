// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


///database of transaction
class User {
  final int? id;
  final String? trans;
  final String? date;
  final String? account;
  final String? category;
  final String? amount;
  final String? note;

  User(
      {this.id,
      this.trans,
      this.date,
      this.account,
      this.category,
      this.amount,
      this.note});

  User.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        trans = res['trans'],
        date = res['date'],
        account = res['account'],
        category = res['category'],
        amount = res['amount'].toString(),
        note = res['note'];

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

///database handler of transaction with getX controller
class DatabaseHandler extends GetxController {
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
      join(path, 'transaction.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, trans TEXT,'
              ' date TEXT, account TEXT, category TEXT,'
              ' amount TEXT, note TEXT)',
        );
      },
      version: 1,
    );
  }

  ///this function is used to insert the transaction into database
  Future<int> insertUser(List<User> users) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var user in users) {
      result = await db.insert('users', user.toMap());
    }
    return result;
  }

  ///this function is used to update user data into database
  Future<int> updateUser({
    required int id,
    required String trans,
    required String date,
    required String account,
    required String category,
    required String amount,
    required String note
  }) async {
    final db = await database;

    final data = {
      'trans': trans,
      'date': date,
      'account': account,
      'category': category,
      'amount': amount,
      'note': note
    };

    final result = await db!.update(
        'users',
        data,
        where: 'id = ?',
        whereArgs: [id]
    );
    return result;
  }

  ///this function is used to fetch data from database
  Future<List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  ///this function is used to delete data from database with the id of the row
  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///this function is used for calculate and return the total income
  Future<String?> calculateIncomeTotal() async {
    String income;
    final dbClient = await initializeDB();
    final result = await dbClient.rawQuery(
        'SELECT SUM(amount) as Total FROM users WHERE trans = ?', ['income']);
    final listResult = result[0].values.toList();
    if (listResult[0].toString().isEmpty) {
      income = '0';
    } else {
      income = listResult[0].toString();
    }
    return income;
  }

  ///this function is used for calculate and return the total expense
  Future<String?> calculateExpenseTotal() async {
    String expense;
    final dbClient = await initializeDB();
    final result = await dbClient.rawQuery(
        'SELECT SUM(amount) as Total FROM users WHERE trans = ?', ['expense']);
    final listResult = result[0].values.toList();
    if (listResult[0].toString().isEmpty) {
      expense = '0';
    } else {
      expense = listResult[0].toString();
    }
    return expense;
  }

  ///this function is used for calculate and return the total assets
  Future<String?> calculateAssetsTotal() async {
    String assets;
    final dbClient = await initializeDB();
    final result = await dbClient.rawQuery(
        "SELECT SUM(amount) as Total FROM users WHERE account = 'Assets'");
    final listResult = result[0].values.toList();
    if (listResult[0].toString().isEmpty) {
      assets = '0';
    } else {
      assets = listResult[0].toString();
    }
    return assets;
  }

  ///this function is used for calculate and return the total liabilities
  Future<String?> calculateLiabilitiesTotal() async {
    String liabilities;
    final dbClient = await initializeDB();
    final result = await dbClient.rawQuery(
        "SELECT SUM(amount) as Total FROM users WHERE account = 'Liabilities'");
    final listResult = result[0].values.toList();
    if (listResult[0].toString().isEmpty) {
      liabilities = '0';
    } else {
      liabilities = listResult[0].toString();
    }
    return liabilities;
  }

  ///this function is used for delete database
  Future<void> deleteDb() async {
    final db = await initializeDB();
    await db.rawQuery('delete from users');
  }

  ///this function is used for fetch data with category
  Future<Map<String, double>> retrieveWithCategory(String trans) async {
    String? amount;
    final Database db = await initializeDB();
    final List<Map<String, Object?>> categoryList =
        await db.rawQuery("SELECT category FROM users WHERE trans = '$trans'");
    final Set<String> categorySet = {};
    for (int i = 0; i < categoryList.length; i++) {
      final String data = categoryList[i]
          .values
          .toString()
          .substring(1, categoryList[i].values.toString().length - 1);
      categorySet.add(data);
    }
    final List<String> listCategory = [...categorySet.toList()];
    final Map<String, double> categoryAmount = {};

    for (int i = 0; i < listCategory.length; i++) {
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
          "SELECT SUM(amount) as Total  FROM users WHERE trans = '$trans'"
              " and category = '${listCategory[i]}'");
      final listResult = queryResult[0].values.toList();
      if (listResult[0].toString().isEmpty) {
        amount = '0';
      } else {
        amount = listResult[0].toString();
      }
      final double amountLast = double.parse(amount);
      categoryAmount.addAll({listCategory[i]: amountLast});
    }
    return categoryAmount;
  }

  ///this function is used for fetch data with category today's
  Future<Map<String, double>> retrieveWithCategoryToday(
      String trans, String date) async {
    String? amount;
    final Database db = await initializeDB();
    final List<Map<String, Object?>> categoryList =
        await db.rawQuery("SELECT category FROM users WHERE trans = '$trans'");
    debugPrint('$categoryList');
    final Set<String> categorySet = {};
    for (int i = 0; i < categoryList.length; i++) {
      final String data = categoryList[i]
          .values
          .toString()
          .substring(1, categoryList[i].values.toString().length - 1);
      categorySet.add(data);
      debugPrint(data);
    }
    final List<String> listCategory = [...categorySet.toList()];
    debugPrint('$listCategory');
    final Map<String, double> categoryAmount = {};

    for (int i = 0; i < listCategory.length; i++) {
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
          "SELECT SUM(amount) as Total  FROM users WHERE trans = '$trans' and"
              " category = '${listCategory[i]}' and date = '$date'");
      final listResult = queryResult[0].values.toList();
      if (listResult[0].toString().isEmpty) {
        amount = '0';
      } else {
        amount = listResult[0].toString();
      }
      debugPrint('amount: $amount');
      final double amountLast = double.parse(amount);
      categoryAmount.addAll({listCategory[i]: amountLast});
    }
    return categoryAmount;
  }

  ///this function is used for fetch data with category of this year
  Future<Map<String, double>> retrieveWithCategoryYear(
      String trans, String date) async {
    String? amount;
    final Database db = await initializeDB();
    debugPrint(date);
    final List<Map<String, Object?>> categoryList =
        await db.rawQuery("SELECT category FROM users WHERE trans = '$trans'");
    debugPrint(date);
    final Set<String> categorySet = {};
    for (int i = 0; i < categoryList.length; i++) {
      final String data = categoryList[i]
          .values
          .toString()
          .substring(1, categoryList[i].values.toString().length - 1);
      categorySet.add(data);
    }
    final List<String> listCategory = [...categorySet.toList()];
    final Map<String, double> categoryAmount = {};

    for (int i = 0; i < listCategory.length; i++) {
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
          "SELECT SUM(amount) as Total  FROM users WHERE trans = '$trans' and"
              " category = '${listCategory[i]}' and date LIKE '%$date'");
      final listResult = queryResult[0].values.toList();
      if (listResult[0].toString().isEmpty) {
        amount = '0';
      } else {
        amount = listResult[0].toString();
      }
      final double amountLast = double.parse(amount);
      categoryAmount.addAll({listCategory[i]: amountLast});
    }
    return categoryAmount;
  }

  ///this function is used for fetch data with category of this month
  Future<Map<String, double>> retrieveWithCategoryMonth(
      String trans, String month, String year) async {
    String? amount;
    final Database db = await initializeDB();
    final List<Map<String, Object?>> categoryList =
        await db.rawQuery("SELECT category FROM users WHERE trans = '$trans'");
    final Set<String> categorySet = {};
    for (int i = 0; i < categoryList.length; i++) {
      final String data = categoryList[i]
          .values
          .toString()
          .substring(1, categoryList[i].values.toString().length - 1);
      categorySet.add(data);
    }
    final List<String> listCategory = [...categorySet.toList()];
    final Map<String, double> categoryAmount = {};

    for (int i = 0; i < listCategory.length; i++) {
      final List<Map<String, Object?>> queryResult = await db.rawQuery(
          "SELECT SUM(amount) as Total  FROM users WHERE trans = '$trans' and"
              " category = '${listCategory[i]}' and date LIKE '$month%' and"
              " date LIKE '%$year'");
      final listResult = queryResult[0].values.toList();
      if (listResult[0].toString().isEmpty) {
        amount = '0';
      } else {
        amount = listResult[0].toString();
      }
      final double amountLast = double.parse(amount);
      categoryAmount.addAll({listCategory[i]: amountLast});
    }
    return categoryAmount;
  }

  ///this function is used for retrieve user database
  Future<List<Map<String, Object?>>> retrieveUsersDatabase() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult;
  }
}
