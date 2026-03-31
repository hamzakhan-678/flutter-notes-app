import 'package:notes_application_mvvm/core/db/db_helper.dart';
import 'package:notes_application_mvvm/models/note_model.dart';

class NoteService {
  final dbHelper = DbHelper.instance;

  Future<List<NoteModel>> getNotes() async {
    final db = await dbHelper.database;

    List<Map<String, dynamic>> maps = await db.query(
      'notes',
      orderBy: 'createdAt DESC',
    );

    return maps.map((e) => NoteModel.fromMap(e)).toList();
  }

  Future<void> insertNote(NoteModel note) async {
    final db = await dbHelper.database;

    await db.insert('notes', note.toMap());
  }

  Future<void> updateNote(NoteModel note) async {
    final db = await dbHelper.database;

    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await dbHelper.database;

    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
