import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'localdata.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE auto_configs(id INTEGER PRIMARY KEY AUTOINCREMENT, configName TEXT, currentDriverId INT, routeId INT, busId INT, mode TEXT, partnerDriverId INT)');
      db.execute(
          'CREATE TABLE favorite_routes(id INTEGER PRIMARY KEY AUTOINCREMENT, passengerId INT, routeId INT, routeName TEXT, stopName TEXT, timeToReach TEXT, mode TEXT)');
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

  static Future<List<Map<String, dynamic>>> getDriverConfigs(
      int driverId) async {
    final db = await LocalDatabase.database();
    return db.query('auto_configs',
        where: 'currentDriverId = ?', whereArgs: [driverId]);
  }

  static Future<List<Map<String, dynamic>>> getFavoriteRoutes(
      int passengerId) async {
    final db = await LocalDatabase.database();
    return db.query('favorite_routes', where: 'passengerId = ?', whereArgs: [passengerId]);
  }

  static Future<void> delete(String table, int id) async {
    final db = await LocalDatabase.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
