import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database(String uid) async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, "$uid.db"),
        onCreate: (db, version) {
      db.execute(
        "CREATE TABLE USERS(username TEXT PRIMARY KEY, imageUrl TEXT)",
      );
      db.execute(
        "CREATE TABLE MESSAGES(id TEXT PRIMARY KEY, sender TEXT, content TEXT, time TEXT, chatName TEXT, FOREIGN KEY(sender) REFERENCES USERS(username))",
      );
    }, version: 1);
  }

  static Future<List<Map<String, dynamic>>> getData(
    String uid,
    String table,
  ) async {
    final db = await DBHelper.database(uid);
    return db.query(table);
  }

  static Future<void> insert(
    String uid,
    String table,
    Map<String, dynamic> data,
  ) async {
    final db = await DBHelper.database(uid);
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
}
