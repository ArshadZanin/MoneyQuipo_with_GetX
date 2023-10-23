import 'package:get/get.dart';
import 'package:money_management/refactored/core/models/transaction.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;
import 'package:path/path.dart';

class TransactionDb extends GetxController {
  Database? _database;

  Future<Database?> get database async {
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
            ''' CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, 
         transactionType TEXT, dateTime TEXT, account TEXT, category TEXT,
               amount NUMERIC, note TEXT)''');
      },
      version: 1,
    );
  }

  Future<int> createTransaction(List<Transaction> transactions) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var transaction in transactions) {
      result = await db.insert('transactions', transaction.toMap());
    }
    return result;
  }

  ///this function is used to update user data into database
  Future<bool> updateTransaction({required Transaction transaction}) async {
    final db = await database;

    final data = transaction.toMap();
    data.remove('id');

    await db!.update(
      'transactions',
      data,
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    return true;
  }

  ///this function is used to delete data from database with the id of the row
  Future<void> deleteTransaction(int id) async {
    final db = await initializeDB();
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///this function is used to fetch data from database
  Future<List<Transaction>> fetchTransactions() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('transactions', orderBy: 'dateTime desc');
    return queryResult.map((e) => Transaction.fromMap(e)).toList();
  }
}
