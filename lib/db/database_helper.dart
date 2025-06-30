import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/time_off_model.dart';
import '../models/file_model.dart';

class DatabaseHelper {
  static const _databaseName = "absensi.db";
  static const _databaseVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  static Database? _database;

  // Inisialisasi database
  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  // Lokasi & nama file DB
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Buat tabel user (dan bisa tambah tabel lain di sini)
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        date TEXT,
        time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE time_off (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        date TEXT,
        reason TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        title TEXT,
        description TEXT
     )
   ''');
  }

  // ===================== USER ========================

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByUsernamePassword(
    String username,
    String password,
  ) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<bool> checkUsernameExists(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  // =================== ABSENSI ======================

  Future<int> insertAttendance(
    String username,
    String date,
    String time,
  ) async {
    final db = await database;
    return await db.insert('attendance', {
      'username': username,
      'date': date,
      'time': time,
    });
  }

  Future<List<Map<String, dynamic>>> getAttendanceLog(String username) async {
    final db = await database;
    return await db.query(
      'attendance',
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'id DESC',
    );
  }

  // =================== TIME OFF ======================

  Future<int> insertTimeOff(TimeOffModel cuti) async {
    final db = await database;
    return await db.insert('time_off', cuti.toMap());
  }

  Future<List<TimeOffModel>> getTimeOffList(String username) async {
    final db = await database;
    final maps = await db.query(
      'time_off',
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'date DESC',
    );
    return maps.map((e) => TimeOffModel.fromMap(e)).toList();
  }

  Future<int> updateTimeOff(TimeOffModel cuti) async {
    final db = await database;
    return await db.update(
      'time_off',
      cuti.toMap(),
      where: 'id = ?',
      whereArgs: [cuti.id],
    );
  }

  Future<int> deleteTimeOff(int id) async {
    final db = await database;
    return await db.delete('time_off', where: 'id = ?', whereArgs: [id]);
  }

  // =================== FILES ======================
  // =================== FILES ======================

Future<int> insertFile(FileModel file) async {
  final db = await database;
  return await db.insert('files', file.toMap());
}

Future<List<FileModel>> getFileList(String username) async {
  final db = await database;
  final maps = await db.query(
    'files',
    where: 'username = ?',
    whereArgs: [username],
    orderBy: 'id DESC',
  );
  return maps.map((e) => FileModel.fromMap(e)).toList();
}

Future<int> updateFile(FileModel file) async {
  final db = await database;
  return await db.update(
    'files',
    file.toMap(),
    where: 'id = ?',
    whereArgs: [file.id],
  );
}

Future<int> deleteFile(int id) async {
  final db = await database;
  return await db.delete('files', where: 'id = ?', whereArgs: [id]);
}

}
