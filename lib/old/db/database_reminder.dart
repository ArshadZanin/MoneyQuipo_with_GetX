// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

///time reminder database

class TimeDb {
  final int? id;
  final String? time;
  final String? reminder;

  TimeDb({this.id, this.time, this.reminder});

  TimeDb.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        time = res['time'],
        reminder = res['reminder'];

  Map<String, Object?> toMap() {
    return {'id': id, 'time': time, 'reminder': reminder};
  }
}

///database handler of reminder with getX controller
class DatabaseHandlerTime extends GetxController{
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
      join(path, 'reminder.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE reminders(id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' time TEXT, reminder TEXT)',
        );
      },
      version: 1,
    );
  }

  ///this function is used to insert the reminder into database
  Future<int> insertReminder(List<TimeDb> reminders) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var reminder in reminders) {
      result = await db.insert('reminders', reminder.toMap());
    }
    debugPrint('$result');
    return result;
  }

  ///this function is used to fetch data from database
  Future<List<TimeDb>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('reminders');
    return queryResult.map((e) => TimeDb.fromMap(e)).toList();
  }

  ///this function is used to delete data from database with the id of the row
  Future<void> deleteTime(int id) async {
    final db = await initializeDB();
    await db.delete(
      'time',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///this function is used to delete database
  Future<void> deleteDb() async {
    final db = await initializeDB();
    await db.rawQuery('delete from reminders');
  }

  ///this function is used to retrieve the time of last add
  Future<String?> retrieveWithTime() async {
    String? time;
    final Database db = await initializeDB();

    final List<Map<String, Object?>> categoryList =
        await db.rawQuery('SELECT time FROM reminders');
    final last = categoryList.length - 1;
    debugPrint('last time :  ${categoryList[last].values}');
    time = categoryList[last].values.toString();
    time = time.replaceAll('(', '').replaceAll(')', '');
    return time;
  }

  ///this function is used to retrieve the boolean value of last add
  Future<bool?> retrieveWithReminder() async {
    String? reminder;
    final Database db = await initializeDB();

    final List<Map<String, Object?>> categoryList =
        await db.rawQuery('SELECT reminder FROM reminders');
    final last = categoryList.length - 1;
    debugPrint('last reminder :  ${categoryList[last].values}');
    reminder = categoryList[last].values.toString();
    reminder = reminder.replaceAll('(', '').replaceAll(')', '');
    debugPrint(reminder);
    if (reminder == 'false') {
      return false;
    } else {
      return true;
    }
  }

  ///this function is used to retrieve the id of last added row
  Future<int?> retrieveWithId() async {
    String? id;
    final Database db = await initializeDB();

    final List<Map<String, Object?>> categoryList =
        await db.rawQuery('SELECT id FROM reminders');
    final last = categoryList.length - 1;
    debugPrint('last time :  ${categoryList[last].values}');
    id = categoryList[last].values.toString();
    id = id.replaceAll('(', '').replaceAll(')', '');
    final int idIs = int.parse(id);
    return idIs;
  }
}
