import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/note.dart';

class DbHelper {



  static final DbHelper instance = DbHelper._init();
  DbHelper._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDb('notes.db');

    return _database!;
  }

  Future<Database> initializeDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    var dbNotes = openDatabase(path, version: 1, onCreate: _createDb);
    return dbNotes;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblNote($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,"
        "$colDescription TEXT, $colPriority INTEGER, $colDate TEXT"
        ")");
  }

  Future<int> insertNote(Note note) async {
    final db = await instance.database;
    var result = await db.insert(tblNote, note.toJson());
    return result;
  }

  Future<List> getNotes() async {
    List<Note> noteList = [];
    final db = await instance.database;

    var result =
        await db.rawQuery("SELECT * FROM $tblNote ORDER BY $colDate ASC");
    for (var element in result) {
      noteList.add(Note.fromJson(element));
    }
    return noteList;
  }

  Future<int?> getCount() async {
    final db = await instance.database;

    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tblNote"));

    return result;
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;

    var result = await db.update(tblNote, note.toJson(),
        where: "$colId = ?", whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    var result = await db.delete(tblNote, where: "$colId = ?", whereArgs: [id]);
    return result;
  }
}
