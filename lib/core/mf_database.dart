import 'dart:io';

import 'package:kpop_lyrics/core/database/artist_table.dart';
import 'package:kpop_lyrics/models/m_artist.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MFDatabase {
  static const _databaseName = "mfKpop.db";
  static const _databaseVersion = 1;

  MFDatabase._privateConstructor();
  static final MFDatabase instance = MFDatabase._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationSupportDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(ArtistTable.createTable);
  }

  Future insert(String table, Map<String, dynamic> row) async {
    final Database db = await database;
    try {
      await db.insert(
        table,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<List<MArtist>> searchArtist(int page, String query) async {
    final db = await database;
    final result = await db.query(
      "artists",
      where: "name like ?",
      whereArgs: ["%$query%"],
      limit: 10,
      offset: (page - 1) * 10,
    );

    return List<MArtist>.generate(
      result.length,
      (index) => MArtist.fromMap(result[index]),
    );
  }
}
