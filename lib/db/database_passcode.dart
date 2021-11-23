// // Flutter imports:
// import 'package:flutter/material.dart';
//
// // Package imports:
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// //income category database
//
// class PasscodeDb {
//   final int? id;
//   final String? passcode;
//   final String? checks;
//
//   PasscodeDb({this.id, this.passcode, this.checks});
//
//   PasscodeDb.fromMap(Map<String, dynamic> res)
//       : id = res["id"],
//         passcode = res["passcode"],
//         checks = res["checks"];
//
//   Map<String, Object?> toMap() {
//     return {'id': id, 'passcode': passcode, 'checks': checks};
//   }
// }
//
// class DatabaseHandlerPasscode {
//   Database? _database;
//
//   Future<Database?> get database async {
//     debugPrint("database getter called");
//
//     if (_database != null) {
//       return _database;
//     }
//
//     _database = await initializeDB();
//
//     return _database;
//   }
//
//   Future<Database> initializeDB() async {
//     String path = await getDatabasesPath();
//     return openDatabase(
//       join(path, 'passcode.db'),
//       onCreate: (database, version) async {
//         await database.execute(
//           "CREATE TABLE passcodes(id INTEGER PRIMARY KEY AUTOINCREMENT, passcode TEXT, checks TEXT)",
//         );
//       },
//       version: 1,
//     );
//   }
//
//   Future<int> insertPasscode(List<PasscodeDb> passcodes) async {
//     int result = 0;
//     final Database db = await initializeDB();
//     for (var passcode in passcodes) {
//       result = await db.insert('passcodes', passcode.toMap());
//     }
//     debugPrint("$result");
//     return result;
//   }
//
//   Future<List<PasscodeDb>> retrieveUsers() async {
//     final Database db = await initializeDB();
//     final List<Map<String, Object?>> queryResult = await db.query('passcodes');
//     return queryResult.map((e) => PasscodeDb.fromMap(e)).toList();
//   }
//
//   Future<void> deleteDb() async {
//     final db = await initializeDB();
//     await db.rawQuery("delete from passcodes");
//   }
//
//   Future<String?> retrievePasscode() async {
//     String? passcode;
//     final Database db = await initializeDB();
//
//     List<Map<String, Object?>> categoryList =
//         await db.rawQuery("SELECT passcode FROM passcodes");
//     var last = categoryList.length - 1;
//     debugPrint("last passcode :  ${categoryList[last].values}");
//     passcode = categoryList[last].values.toString();
//     passcode = passcode.replaceAll("(", "").replaceAll(")", "");
//     return passcode;
//   }
//
//   Future<bool?> retrieveCheck() async {
//     String? check;
//     final Database db = await initializeDB();
//
//     List<Map<String, Object?>> categoryList =
//         await db.rawQuery("SELECT checks FROM passcodes");
//     var last = categoryList.length - 1;
//     debugPrint("last checks :  ${categoryList[last].values}");
//     check = categoryList[last].values.toString();
//     check = check.replaceAll("(", "").replaceAll(")", "");
//     debugPrint(check);
//     if (check == 'false') {
//       return false;
//     } else {
//       return true;
//     }
//   }
//
//   Future<int?> retrieveWithId() async {
//     String? id;
//     final Database db = await initializeDB();
//
//     List<Map<String, Object?>> categoryList =
//         await db.rawQuery("SELECT id FROM passcodes");
//     var last = categoryList.length - 1;
//     debugPrint("last time :  ${categoryList[last].values}");
//     id = categoryList[last].values.toString();
//     id = id.replaceAll("(", "").replaceAll(")", "");
//     int idIs = int.parse(id);
//     return idIs;
//   }
// }
