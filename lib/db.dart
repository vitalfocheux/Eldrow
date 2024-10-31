import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as path;

class GameResult {
  final int? id;
  final String word;
  final int attempts;
  final bool success;
  final DateTime date;
  final String mode;
  final int winStreak;
  final String language;

  GameResult({this.id, required this.word, required this.attempts, required this.success, required this.date, required this.mode, required this.winStreak, required this.language});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'attempts': attempts,
      'success': success ? 1 : 0,
      'date': date.toIso8601String(),
      'mode': mode,
      'winStreak': winStreak,
      'language': language,
    };
  }

  static GameResult fromMap(Map<String, dynamic> map) {
    return GameResult(
      id: map['id'],
      word: map['word'],
      attempts: map['attempts'],
      success: map['success'] == 1,
      date: DateTime.parse(map['date']),
      mode: map['mode'],
      winStreak: map['winStreak'],
      language: map['language'],
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class GameResultDatabase {
  static final GameResultDatabase instance = GameResultDatabase._init();
  static Database? _database;

  GameResultDatabase._init();

  Future<Database> get database async {
    if(kDebugMode){
      if(_database != null){
        print('Database already initialized');
      }else{
        print('Database not initialized');
      }
    }
    if (_database != null){
      return _database!;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    if(Platform.isWindows || Platform.isLinux || Platform.isMacOS){
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String dbPath;

    if(Platform.isAndroid || Platform.isIOS){
      var databasesPath = await getDatabasesPath();
      dbPath = path.join(databasesPath, 'game_results.db');
    }else{
      var directory = Directory.systemTemp;
      dbPath = path.join(directory.path, 'game_results.db');
    }

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE game_results (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      word TEXT NOT NULL,
      attempts INTEGER NOT NULL,
      success INTEGER NOT NULL,
      date TEXT NOT NULL,
      mode TEXT NOT NULL,
      winStreak INTEGER NOT NULL,
      language TEXT NOT NULL
    )
    ''');
  }

  Future<int> insertGameResult(GameResult result) async {
    final db = await instance.database;
    return await db.insert('game_results', result.toMap());
  }

  Future<List<GameResult>> fetchAllResults() async {
    final db = await instance.database;
    final results = await db.query('game_results');

    return results.map((map) => GameResult.fromMap(map)).toList();
  }

  Future<List<GameResult>> fetchResultsByMode(String mode) async {
    final db = await instance.database;
    final results = await db.query(
      'game_results',
      where: 'mode = ?',
      whereArgs: [mode],
    );

    return results.map((map) => GameResult.fromMap(map)).toList();
  }

  Future<int> deleteAllResults() async {
    final db = await instance.database;
    return await db.delete('game_results');
  }

  Future close() async {
    print('Closing database');
    final db = await instance.database;
    db.close();
  }
}