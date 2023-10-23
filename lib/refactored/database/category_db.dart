
import 'package:get/get.dart';
import 'package:money_management/refactored/models/category.dart';
import 'package:money_management/refactored/models/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDb extends GetxController{
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
      join(path, 'incomeCategory.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT,
               name TEXT NOT NULL, type TEXT NOT NULL)''',
        );
      },
      version: 1,
    );
  }

  ///this function is used to insert the category into database
  Future<int> insetCategory(
    List<Category> categories,
  ) async {
    int result = 0;
    final Database db = await initializeDB();
    for (Category  category in categories) {
      result = await db.insert('categories', category.toMap());
    }
    return result;
  }

  ///this function is used to update category into database
  Future<int> updateCategory(int id, String category) async {
    final db = await database;
    final data = {'name': category};
    final result = await db!
        .update('categories', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  ///this function is used to fetch data from database
  Future<List<Category>> fetchCategories({
    required TransactionType type,
  }) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('categories',where: 'type = ?', whereArgs: [type.name]);
    return queryResult.map((e) => Category.fromMap(e)).toList();
  }

  ///this function is used to delete data from database with the id of the row
  Future<void> deleteCategory(int id) async {
    final db = await initializeDB();
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///this function is used to delete database
  Future<void> deleteDb() async {
    final db = await initializeDB();
    await db.rawQuery('delete from categories');
  }
}
