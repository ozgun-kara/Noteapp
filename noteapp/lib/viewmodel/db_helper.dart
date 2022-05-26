import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/note.dart';

class DbHelper {



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
