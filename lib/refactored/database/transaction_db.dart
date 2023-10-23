import 'package:get/get.dart';
import 'package:money_management/refactored/models/transaction.dart';
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

  ///this function is used to fetch data from database
  Future<List<Transaction>> fetchTransactions() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('transactions');
    return queryResult.map((e) => Transaction.fromMap(e)).toList();
  }
}
