import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'localdata.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE auto_configs(id INTEGER PRIMARY KEY AUTOINCREMENT, configName TEXT, currentDriverId INT, routeId INT, busId INT, mode TEXT, partnerDriverId INT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await LocalDatabase.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getDriverConfigs (String table, int driverId) async {
    final db = await LocalDatabase.database();
    return db.query(table, where: 'currentDriverId = ?', whereArgs: [ driverId ]);
  }

  static Future<void> delete(String table, int id) async {
    final db = await LocalDatabase.database();
    db.delete(table, where: 'id = ?', whereArgs: [ id ]);
  }
}
