import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:todo_sqlite/model.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,age INTEGER NOT NULL, description TEXT NOT NULL, email TEXT)",
    );
  }

  Future<noteModel> insert(noteModel notemodel) async {
    var dbclient = await db;
    await dbclient!.insert('notes', notemodel.toMap());
    return notemodel;
  }

  Future<List<noteModel>> getNotesList() async {
    var dbclient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbclient!.query('notes');
    return queryResult
        .map((e) => noteModel.fromMap(e))
        .toList()
        .reversed
        .toList();
  }

  Future<int> delete(int id) async {
    var dbclient = await db;
    return await dbclient!.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(noteModel notemodel) async {
    var dbclient = await db;
    return await dbclient!.update('notes', notemodel.toMap(),
        where: 'id = ?', whereArgs: [notemodel.id]);
  }
}
