import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:note_application/models/notes_model.dart';
import 'dart:io' as io;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, age INTEGER NOT NULL, email TEXT NOT NULL, title TEXT NOT NULL, description TEXT NOT NULL)",
    );
  }

  Future<NoteModel> insertData(NoteModel noteModel) async {
    var dbClient = await db;
    await dbClient!.insert('notes', noteModel.toMap());
    return noteModel;
  }

  Future<List<NoteModel>> getNoteList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query("notes");
    return queryResult.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(NoteModel noteModel) async {
    var dbClient = await db;
    return await dbClient!.update('notes', noteModel.toMap(),
        where: 'id = ?', whereArgs: [noteModel.id]);
  }
}
